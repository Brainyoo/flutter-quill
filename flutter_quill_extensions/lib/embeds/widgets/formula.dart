import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:math_keyboard/math_keyboard.dart';

class Formula extends StatefulWidget {
  const Formula({
    required this.node,
    required this.context,
    required this.readOnly,
    required this.controller,
  });

  final base.Embed node;
  final BuildContext context;
  final bool readOnly;
  final QuillController controller;

  String get _value {
    return node.value.data;
  }

  @override
  State<Formula> createState() => _FormulaState()..isEditing = _value.isEmpty;
}

class _FormulaState extends State<Formula> {
  var isEditing = false;
  var mathController = MathFieldEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) return Math.tex(widget._value);

    if (isEditing) {
      return MathField(
        controller: mathController,
        variables: const ['x', 'y', 'z'],
        onChanged: (value) {},
        onSubmitted: _updateNode,
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          isEditing = true;
        });
      },
      child: Math.tex(widget._value),
    );
  }

  void _updateNode(String newValue) {
    widget.controller.replaceText(widget.node.documentOffset,
        widget.node.length, BlockEmbed.formula(newValue), null);
    setState(() {
      isEditing = false;
    });
  }
}
