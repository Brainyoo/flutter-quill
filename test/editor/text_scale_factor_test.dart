import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
// Not part of the public API (not exported from flutter_quill.dart), but
// importing implementation files from this package's own tests is an
// established pattern elsewhere in this repo.
import 'package:flutter_quill/src/editor/widgets/inverse_text_scale.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedSizeEmbedBuilder extends EmbedBuilder {
  _FixedSizeEmbedBuilder({required this.scale, this.onTap});

  final bool scale;
  final VoidCallback? onTap;

  @override
  String get key => 'fixedBox';

  @override
  bool get expanded => false;

  @override
  bool get scaleWithText => scale;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: const SizedBox(key: Key('fixed-box'), width: 40, height: 20),
      );
}

void main() {
  late QuillController controller;

  setUp(() => controller = QuillController.basic());
  tearDown(() => controller.dispose());

  Widget app(double factor) => MaterialApp(
    home: QuillEditor.basic(
      controller: controller,
      config: QuillEditorConfig(textScaleFactor: factor),
    ),
  );

  group('QuillEditorConfig.textScaleFactor', () {
    testWidgets('composes ambient text scaler inside the editor subtree', (
      tester,
    ) async {
      await tester.pumpWidget(app(2));
      final context = tester.element(find.byType(QuillRawEditor));
      expect(MediaQuery.textScalerOf(context).scale(16), 32);
    });

    testWidgets('factor 1.0 keeps the ambient scaler untouched', (
      tester,
    ) async {
      await tester.pumpWidget(app(1));
      final context = tester.element(find.byType(QuillRawEditor));
      expect(MediaQuery.textScalerOf(context).scale(16), 16);
    });

    testWidgets('does not modify the document', (tester) async {
      controller.document.insert(0, 'Hello World');
      final before = jsonEncode(controller.document.toDelta().toJson());
      await tester.pumpWidget(app(2.5));
      await tester.pump();
      expect(jsonEncode(controller.document.toDelta().toJson()), before);
    });

    test('rejects non-positive or non-finite factors', () {
      // The assert is what actually protects debug builds; release builds
      // strip it and fall back to 1.0 instead (see the field doc comment).
      for (final invalid in [0.0, -1.0, double.nan, double.infinity]) {
        expect(
          () => QuillEditorConfig(textScaleFactor: invalid),
          throwsAssertionError,
          reason: 'textScaleFactor: $invalid must be rejected',
        );
      }
    });
  });

  group('structural metrics scale with the factor', () {
    testWidgets('ordered list leading slot doubles at factor 2', (
      tester,
    ) async {
      controller.document
        ..insert(0, 'One')
        ..format(3, 1, Attribute.ol);
      await tester.pumpWidget(app(1));
      final normalWidth = tester.getSize(find.byType(QuillNumberPoint)).width;

      await tester.pumpWidget(app(2));
      await tester.pump();
      final scaledWidth = tester.getSize(find.byType(QuillNumberPoint)).width;
      expect(scaledWidth, moreOrLessEquals(normalWidth * 2));
    });

    testWidgets('unordered list leading slot doubles at factor 2', (
      tester,
    ) async {
      controller.document
        ..insert(0, 'One')
        ..format(3, 1, Attribute.ul);
      await tester.pumpWidget(app(1));
      final normalWidth = tester.getSize(find.byType(QuillBulletPoint)).width;

      await tester.pumpWidget(app(2));
      await tester.pump();
      final scaledWidth = tester.getSize(find.byType(QuillBulletPoint)).width;
      expect(scaledWidth, moreOrLessEquals(normalWidth * 2));
    });

    testWidgets('code block line-number leading slot doubles at factor 2', (
      tester,
    ) async {
      controller.document
        ..insert(0, 'code')
        ..format(4, 1, Attribute.codeBlock);
      await tester.pumpWidget(app(1));
      final normalWidth = tester.getSize(find.byType(QuillNumberPoint)).width;

      await tester.pumpWidget(app(2));
      await tester.pump();
      final scaledWidth = tester.getSize(find.byType(QuillNumberPoint)).width;
      expect(scaledWidth, moreOrLessEquals(normalWidth * 2));
    });

    testWidgets('indent attribute contribution to the leading offset '
        'scales with the factor', (tester) async {
      // defaultIndentWidthBuilder adds `fontSize * indent.value` on top of
      // the (here zero-by-default) block horizontal spacing, so comparing
      // an indented against a non-indented line isolates that contribution.
      Future<double> lineLeft(double factor, {required bool indented}) async {
        final doc = Document()..insert(0, 'Text');
        if (indented) {
          doc.format(4, 1, Attribute.indentL2);
        }
        controller.document = doc;
        await tester.pumpWidget(app(factor));
        await tester.pump();
        return tester.getTopLeft(find.byType(RichText).first).dx;
      }

      final delta1 =
          await lineLeft(1, indented: true) -
          await lineLeft(1, indented: false);
      final delta2 =
          await lineLeft(2, indented: true) -
          await lineLeft(2, indented: false);

      expect(
        delta1,
        greaterThan(0),
        reason: 'Test setup broken: indent produces no offset',
      );
      expect(delta2, moreOrLessEquals(delta1 * 2, epsilon: 0.5));
    });

    testWidgets('checkbox leading scales with the factor', (tester) async {
      controller.document
        ..insert(0, 'Task')
        ..format(4, 1, Attribute.unchecked);

      Future<double> checkboxWidth(double factor) async {
        await tester.pumpWidget(app(factor));
        await tester.pump();
        return tester.getSize(find.byType(QuillCheckboxPoint)).width;
      }

      final normalWidth = await checkboxWidth(1);
      expect(normalWidth, greaterThan(0));
      expect(await checkboxWidth(2), moreOrLessEquals(normalWidth * 2));
    });

    testWidgets('block horizontal spacing scales with the factor', (
      tester,
    ) async {
      const indent = 40.0;
      controller.document
        ..insert(0, 'Quote')
        ..format(5, 1, Attribute.blockQuote);

      // The default is HorizontalSpacing(0, 0) — without an override the
      // scaling would not be measurable.
      DefaultStylesOverride quoteIndent(double left) => DefaultStylesOverride(
        quote: (value) => DefaultTextBlockStyle(
          value.style,
          HorizontalSpacing(left, 0),
          value.verticalSpacing,
          value.lineSpacing,
          value.decoration,
        ),
      );

      Future<double> quoteLeft(double factor, double left) async {
        await tester.pumpWidget(
          MaterialApp(
            home: QuillEditor.basic(
              controller: controller,
              config: QuillEditorConfig(
                textScaleFactor: factor,
                customStyles: quoteIndent(left),
              ),
            ),
          ),
        );
        await tester.pump();
        return tester.getTopLeft(find.byType(RichText).first).dx;
      }

      // The line indent inside the block already scales; the difference of
      // the two deltas isolates the contribution of the block padding.
      final baseline = await quoteLeft(2, 0) - await quoteLeft(1, 0);
      final withIndent =
          await quoteLeft(2, indent) - await quoteLeft(1, indent);
      expect(
        withIndent - baseline,
        moreOrLessEquals(indent, epsilon: 0.5),
        reason: 'Block indent must grow from 40 to 80',
      );
    });

    testWidgets('vertical line spacing scales with the factor', (tester) async {
      // h1 on the SECOND line: its top spacing (16) then sits between the
      // two lines and is measurable as a gap.
      controller.document
        ..insert(0, 'Paragraph\nHeading')
        ..format(10, 7, Attribute.h1);

      Future<double> gapBetweenLines(double factor) async {
        await tester.pumpWidget(app(factor));
        await tester.pump();
        final lines = find.byType(RichText);
        final first = tester.getBottomLeft(lines.first).dy;
        final second = tester.getTopLeft(lines.at(1)).dy;
        return second - first;
      }

      final normalGap = await gapBetweenLines(1);
      expect(
        normalGap,
        greaterThan(4),
        reason: 'Test setup broken: gap between the lines is missing',
      );
      final scaledGap = await gapBetweenLines(2);
      expect(scaledGap, moreOrLessEquals(normalGap * 2, epsilon: 0.5));
    });
  });

  group('scaleWithText', () {
    Widget embedApp({
      required bool scale,
      required double factor,
      VoidCallback? onTap,
    }) => MaterialApp(
      home: QuillEditor.basic(
        controller: controller,
        config: QuillEditorConfig(
          textScaleFactor: factor,
          embedBuilders: [_FixedSizeEmbedBuilder(scale: scale, onTap: onTap)],
        ),
      ),
    );

    void insertInlineEmbed() {
      final doc = Document.fromJson(
        jsonDecode(
              '[{"insert":"before "},{"insert":{"fixedBox":"{}"}},'
              '{"insert":" after\\n"}]',
            )
            as List,
      );
      controller.document = doc;
    }

    testWidgets('false keeps the embed at natural size', (tester) async {
      insertInlineEmbed();
      await tester.pumpWidget(embedApp(scale: false, factor: 2));
      await tester.pump();
      final rect = tester.getRect(find.byKey(const Key('fixed-box')));
      expect(rect.width, moreOrLessEquals(40));
      expect(rect.height, moreOrLessEquals(20));
    });

    testWidgets('default true lets the embed scale with the text', (
      tester,
    ) async {
      insertInlineEmbed();
      await tester.pumpWidget(embedApp(scale: true, factor: 2));
      await tester.pump();
      final rect = tester.getRect(find.byKey(const Key('fixed-box')));
      expect(rect.width, moreOrLessEquals(80));
      expect(rect.height, moreOrLessEquals(40));
    });

    testWidgets('false also neutralises text inside the embed '
        '(e.g. error placeholders)', (tester) async {
      insertInlineEmbed();
      await tester.pumpWidget(embedApp(scale: false, factor: 2));
      await tester.pump();
      final context = tester.element(find.byKey(const Key('fixed-box')));
      expect(MediaQuery.textScalerOf(context).scale(16), 16);
    });

    testWidgets(
      'true neutralises the inner MediaQuery too — the auto-transform is '
      'the single source of scaling (no quadratic growth for text inside)',
      (tester) async {
        insertInlineEmbed();
        await tester.pumpWidget(embedApp(scale: true, factor: 2));
        await tester.pump();
        // Inside 1× — the outer WidgetSpan transform provides the scaling.
        final context = tester.element(find.byKey(const Key('fixed-box')));
        expect(MediaQuery.textScalerOf(context).scale(16), 16);
        // Outside: rendered at exactly ×2 (not ×4).
        final rect = tester.getRect(find.byKey(const Key('fixed-box')));
        expect(rect.width, moreOrLessEquals(80));
      },
    );

    testWidgets('false still routes taps to the embed through '
        'RenderInverseTextScale', (tester) async {
      insertInlineEmbed();
      var tapped = false;
      await tester.pumpWidget(
        embedApp(scale: false, factor: 2, onTap: () => tapped = true),
      );
      await tester.pump();

      // warnIfMissed: false — the plain SizedBox found by the key doesn't
      // register itself as a hit-test target (it neither paints nor calls
      // hitTestSelf); the surrounding GestureDetector does, at the same
      // bounds. What's actually under test is whether `tapped` flips, i.e.
      // whether the tap reaches that GestureDetector through
      // RenderInverseTextScale's hit-test transform at all.
      await tester.tap(find.byKey(const Key('fixed-box')), warnIfMissed: false);
      await tester.pump();

      expect(
        tapped,
        isTrue,
        reason:
            'tap must reach the embed through the inverse paint '
            'transform / hit-test transform, not just land nearby',
      );
    });
  });

  group('RenderInverseTextScale', () {
    testWidgets(
      "computeDryBaseline scales the child's dry baseline by 1 / scale",
      (tester) async {
        // Deliberately goes through the public getDryBaseline() wrapper on
        // both sides rather than calling computeDistanceToActualBaseline /
        // computeDryBaseline directly: the "wet" baseline methods assert
        // they're only called through Flutter's own calling convention
        // (getDistanceToBaseline, invoked from a parent's performLayout /
        // paint), which ad-hoc test code cannot satisfy. getDryBaseline has
        // no such restriction — "it's ok to call this method when this
        // RenderBox's layout is outdated" per its own doc comment — so it
        // doubles as a safe, direct way to check the 1/scale formula here.
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(
              child: InverseTextScale(
                scale: 2,
                child: Text('Q', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        );

        final renderObject = tester.renderObject<RenderInverseTextScale>(
          find.byType(InverseTextScale),
        );
        final constraints = renderObject.constraints;
        final childConstraints = BoxConstraints(
          maxWidth: constraints.maxWidth.isFinite
              ? constraints.maxWidth * renderObject.scale
              : double.infinity,
        );

        final childDryBaseline = renderObject.child!.getDryBaseline(
          childConstraints,
          TextBaseline.alphabetic,
        );
        expect(
          childDryBaseline,
          isNotNull,
          reason: 'Test setup broken: text provides no baseline',
        );

        final dryBaseline = renderObject.getDryBaseline(
          constraints,
          TextBaseline.alphabetic,
        );

        expect(
          dryBaseline,
          moreOrLessEquals(childDryBaseline! / renderObject.scale),
        );
      },
    );
  });
}
