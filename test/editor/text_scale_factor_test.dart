import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/src/editor/raw_editor/raw_editor.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedSizeEmbedBuilder extends EmbedBuilder {
  _FixedSizeEmbedBuilder({required this.scale});

  final bool scale;

  @override
  String get key => 'fixedBox';

  @override
  bool get expanded => false;

  @override
  bool get scaleWithText => scale;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) =>
      const SizedBox(key: Key('fixed-box'), width: 40, height: 20);
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
    testWidgets('composes ambient text scaler inside the editor subtree',
        (tester) async {
      await tester.pumpWidget(app(2.0));
      final context = tester.element(find.byType(QuillRawEditor));
      expect(MediaQuery.textScalerOf(context).scale(16), 32);
    });

    testWidgets('factor 1.0 keeps the ambient scaler untouched',
        (tester) async {
      await tester.pumpWidget(app(1.0));
      final context = tester.element(find.byType(QuillRawEditor));
      expect(MediaQuery.textScalerOf(context).scale(16), 16);
    });

    testWidgets('does not modify the document', (tester) async {
      controller.document.insert(0, 'Hallo Welt');
      final before = jsonEncode(controller.document.toDelta().toJson());
      await tester.pumpWidget(app(2.5));
      await tester.pump();
      expect(jsonEncode(controller.document.toDelta().toJson()), before);
    });
  });

  group('structural metrics scale with the factor', () {
    testWidgets('ordered list leading slot doubles at factor 2',
        (tester) async {
      controller.document
        ..insert(0, 'Eins')
        ..format(4, 1, Attribute.ol);
      await tester.pumpWidget(app(1.0));
      final normalWidth = tester.getSize(find.byType(QuillNumberPoint)).width;

      await tester.pumpWidget(app(2.0));
      await tester.pump();
      final scaledWidth = tester.getSize(find.byType(QuillNumberPoint)).width;
      expect(scaledWidth, moreOrLessEquals(normalWidth * 2));
    });

    testWidgets('vertical line spacing scales with the factor',
        (tester) async {
      controller.document
        ..insert(0, 'Absatz2\n')
        ..insert(0, 'Überschrift\n')
        ..format(0, 11, Attribute.h1);

      Future<double> gapBetweenLines(double factor) async {
        await tester.pumpWidget(app(factor));
        await tester.pump();
        final lines = find.byType(RichText);
        final first = tester.getBottomLeft(lines.first).dy;
        final second = tester.getTopLeft(lines.at(1)).dy;
        return second - first;
      }

      final normalGap = await gapBetweenLines(1.0);
      final scaledGap = await gapBetweenLines(2.0);
      expect(scaledGap, moreOrLessEquals(normalGap * 2, epsilon: 0.5));
    });
  });

  group('scaleWithText', () {
    Widget embedApp({required bool scale, required double factor}) =>
        MaterialApp(
          home: QuillEditor.basic(
            controller: controller,
            config: QuillEditorConfig(
              textScaleFactor: factor,
              embedBuilders: [_FixedSizeEmbedBuilder(scale: scale)],
            ),
          ),
        );

    void insertInlineEmbed() {
      final doc = Document.fromJson(jsonDecode(
        '[{"insert":"davor "},{"insert":{"fixedBox":"{}"}},'
        '{"insert":" danach\\n"}]',
      ) as List);
      controller.document = doc;
    }

    testWidgets('false keeps the embed at natural size', (tester) async {
      insertInlineEmbed();
      await tester.pumpWidget(embedApp(scale: false, factor: 2.0));
      await tester.pump();
      final rect = tester.getRect(find.byKey(const Key('fixed-box')));
      expect(rect.width, moreOrLessEquals(40));
      expect(rect.height, moreOrLessEquals(20));
    });

    testWidgets('default true lets the embed scale with the text',
        (tester) async {
      insertInlineEmbed();
      await tester.pumpWidget(embedApp(scale: true, factor: 2.0));
      await tester.pump();
      final rect = tester.getRect(find.byKey(const Key('fixed-box')));
      expect(rect.width, moreOrLessEquals(80));
      expect(rect.height, moreOrLessEquals(40));
    });
  });
}
