import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/src/l10n/extensions/localizations_ext.dart';
import 'package:flutter_quill_test/flutter_quill_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late QuillController controller;
  var didCopy = false;

  setUp(() {
    controller = QuillController.basic();
  });

  tearDown(() {
    controller.dispose();
  });

  group('QuillEditor', () {
    testWidgets('Keyboard entered text is stored in document', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuillEditor.basic(
            controller: controller,
            config: const QuillEditorConfig(),
          ),
        ),
      );
      await tester.quillEnterText(find.byType(QuillEditor), 'test\n');

      expect(controller.document.toPlainText(), 'test\n');
    });

    testWidgets(
        'text entry emulation without trailing newline is stored in document',
        (tester) async {
      // Flutter Driver's text entry emulation (`enter_text`) replaces the
      // whole editing value WITHOUT the document's trailing newline. The
      // resulting diff must not delete that final newline (illegal in a
      // Quill document — used to throw inside Document.compose and silently
      // drop the input).
      await tester.pumpWidget(
        MaterialApp(
          home: QuillEditor.basic(
            controller: controller,
            config: const QuillEditorConfig(),
          ),
        ),
      );
      await tester.tap(find.byType(QuillEditor));
      await tester.pumpAndSettle();

      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'hello',
          selection: TextSelection.collapsed(offset: 5),
        ),
      );
      await tester.pump();
      expect(controller.document.toPlainText(), 'hello\n');

      // Full replacement of a non-empty document, again without newline.
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'replaced',
          selection: TextSelection.collapsed(offset: 8),
        ),
      );
      await tester.pump();
      expect(controller.document.toPlainText(), 'replaced\n');

      // Incremental typing like a real IME (based on the remote value
      // including the trailing newline) must keep working.
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'replaced!\n',
          selection: TextSelection.collapsed(offset: 9),
        ),
      );
      await tester.pump();
      expect(controller.document.toPlainText(), 'replaced!\n');
    });

    testWidgets(
        'IME backspace merging an empty trailing line still deletes it',
        (tester) async {
      // Regression guard for the trailing-newline trim: a legitimate IME
      // edit that consumes the tail of the old text but still ends with the
      // terminal newline (old "abc\n\n" -> new "abc\n") must be applied,
      // not turned into a no-op.
      controller.replaceText(
        0,
        0,
        'abc\n',
        const TextSelection.collapsed(offset: 4),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: QuillEditor.basic(
            controller: controller,
            config: const QuillEditorConfig(),
          ),
        ),
      );
      expect(controller.document.toPlainText(), 'abc\n\n');

      await tester.tap(find.byType(QuillEditor));
      await tester.pumpAndSettle();

      // Backspace on the empty line: cursor was at 4, deletes the char
      // before it, cursor ends up at 3 — exactly what a real IME sends.
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'abc\n',
          selection: TextSelection.collapsed(offset: 3),
        ),
      );
      await tester.pump();
      expect(controller.document.toPlainText(), 'abc\n');
    });

    testWidgets('insertContent is handled correctly', (tester) async {
      String? latestUri;
      await tester.pumpWidget(
        MaterialApp(
          home: QuillEditor(
            focusNode: FocusNode(),
            scrollController: ScrollController(),
            controller: controller,
            config: QuillEditorConfig(
              autoFocus: true,
              expands: true,
              contentInsertionConfiguration: ContentInsertionConfiguration(
                onContentInserted: (content) {
                  latestUri = content.uri;
                },
                allowedMimeTypes: <String>['image/gif'],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(QuillEditor));
      await tester.quillEnterText(find.byType(QuillEditor), 'test\n');
      await tester.idle();

      const uri =
          'content://com.google.android.inputmethod.latin.fileprovider/test.gif';
      final messageBytes = const JSONMessageCodec().encodeMessage(<
        String,
        dynamic
      >{
        'args': <dynamic>[
          -1,
          'TextInputAction.commitContent',
          jsonDecode(
            '{"mimeType": "image/gif", "data": [0,1,0,1,0,1,0,0,0], "uri": "$uri"}',
          ),
        ],
        'method': 'TextInputClient.performAction',
      });

      Object? error;
      try {
        await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
          'flutter/textinput',
          messageBytes,
          (_) {},
        );
      } catch (e) {
        error = e;
      }
      expect(error, isNull);
      expect(latestUri, equals(uri));
    });

    Widget customBuilder(BuildContext context, QuillRawEditorState state) {
      return AdaptiveTextSelectionToolbar(
        anchors: state.contextMenuAnchors,
        children: [
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    didCopy = true;
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
          ),
        ],
      );
    }

    testWidgets('custom context menu builder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuillEditor(
            focusNode: FocusNode(),
            scrollController: ScrollController(),
            controller: controller,
            config: QuillEditorConfig(
              autoFocus: true,
              expands: true,
              contextMenuBuilder: customBuilder,
            ),
          ),
        ),
      );

      // Long press to show menu
      await tester.longPress(find.byType(QuillEditor));
      await tester.pumpAndSettle();

      // Verify custom widget shows
      expect(find.byIcon(Icons.copy), findsOneWidget);

      await tester.tap(find.byIcon(Icons.copy));
      expect(didCopy, isTrue);
    });

    testWidgets(
      'QuillEditorOpenSearchAction should not throw an exception when the required localization delegates are provided',
      (tester) async {
        final editorFocusNode = FocusNode();
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates:
                FlutterQuillLocalizations.localizationsDelegates,
            home: QuillEditor.basic(
              controller: controller,
              config: const QuillEditorConfig(),
              focusNode: editorFocusNode,
            ),
          ),
        );
        // Required, otherwise the action shortcuts won't be invoked.
        editorFocusNode.requestFocus();

        await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.control);

        await tester.pump();

        final exception = tester.takeException();
        expect(
          exception,
          isNot(isInstanceOf<MissingFlutterQuillLocalizationException>()),
        );

        expect(exception, isNull);
      },
    );

    testWidgets(
      'should throw MissingFlutterQuillLocalizationException if the delegate not provided',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) => Text(context.loc.font)),
          ),
        );

        final exception = tester.takeException();

        expect(exception, isNotNull);
        expect(exception, isA<MissingFlutterQuillLocalizationException>());
      },
    );

    testWidgets(
      'should not throw MissingFlutterQuillLocalizationException if the delegate is provided',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates:
                FlutterQuillLocalizations.localizationsDelegates,
            home: Builder(builder: (context) => Text(context.loc.font)),
          ),
        );

        final exception = tester.takeException();

        expect(exception, isNull);
        expect(
          exception,
          isNot(isA<MissingFlutterQuillLocalizationException>()),
        );
      },
    );

    testWidgets(
      'should throw MissingFlutterQuillLocalizationException if the delegate is not provided',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) => Text(context.loc.font)),
          ),
        );

        final exception = tester.takeException();

        expect(exception, isNotNull);
        expect(exception, isA<MissingFlutterQuillLocalizationException>());
      },
    );
  });
}
