import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class ClozeEmbedBuilder implements EmbedBuilder {
  ClozeEmbedBuilder({required this.controller});

  QuillController controller;

  @override
  String get key => 'clozeEmbed';

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final notes = ClozeBlockEmbed(node.value.data).document;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 2),
          ),
          child: Text(
            notes.toPlainText().replaceAll('\n', ' '),
            style: DefaultStyles.getInstance(context).paragraph!.style,
          ),
          onPressed: () => _addEditCloze(context, document: notes),
        ),
      ),
    );
  }

  Future<void> _addEditCloze(BuildContext context, {Document? document}) async {
    final isEditing = document != null;
    final quillEditorController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    final textController = TextEditingController(text: document?.toPlainText());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.only(left: 16, top: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${isEditing ? 'Edit' : 'Add'} cloze'),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            )
          ],
        ),
        content: TextField(
          controller: textController,
        ),
      ),
    );

    quillEditorController.replaceText(0, 0, textController.text, null);

    if (quillEditorController.document.isEmpty()) return;

    quillEditorController.formatText(0, quillEditorController.document.length,
        const IdAttribute('SuperTolleSuperID'));

    final block = BlockEmbed.custom(
      ClozeBlockEmbed.fromDocument(quillEditorController.document),
    );
    final innerController = controller;
    final index = innerController.selection.baseOffset;
    final length = innerController.selection.extentOffset - index;

    if (isEditing) {
      final offset =
          getEmbedNode(innerController, innerController.selection.start).offset;
      innerController.replaceText(
          offset, 1, block, TextSelection.collapsed(offset: offset));
    } else {
      innerController.replaceText(index, length, block, null);
    }
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget);
  }

  @override
  bool get expanded => true;

  @override
  String toPlainText(Embed node) => Embed.kObjectReplacementCharacter;
}

class ClozeBlockEmbed extends CustomBlockEmbed {
  const ClozeBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'clozeEmbed';

  static ClozeBlockEmbed fromDocument(Document document) =>
      ClozeBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}
