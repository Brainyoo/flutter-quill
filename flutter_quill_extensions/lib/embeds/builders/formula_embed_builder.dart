import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart';
import '../widgets/formula.dart';

class FormulaEmbedBuilder implements EmbedBuilder {
  @override
  String get key => BlockEmbed.formulaType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    base.Embed node,
    bool readOnly,
  ) {
    return Formula(
        node: node,
        context: context,
        readOnly: readOnly,
        controller: controller);
  }
}
