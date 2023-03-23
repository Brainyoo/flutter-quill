import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../models/table_model.dart';

class TableButton extends StatelessWidget {
  const TableButton({
    required this.icon,
    required this.controller,
    required this.iconSize,
    required this.buttonSize,
    this.fillColor,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final double buttonSize;

  final Color? fillColor;

  final QuillController controller;

  final QuillIconTheme? iconTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor =
        iconTheme?.iconUnselectedFillColor ?? (fillColor ?? theme.canvasColor);

    return QuillIconButton(
      icon: Icon(icon, size: iconSize, color: iconColor),
      highlightElevation: 0,
      hoverElevation: 0,
      size: buttonSize,
      fillColor: iconFillColor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      onPressed: _addTable,
    );
  }

  void _addTable() {
    final newTable = TableModel.withRowCountAndColumnCount(2, 3);
    final block = BlockEmbed.table(jsonEncode(newTable.toJson()));
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    controller.replaceText(index, length, block, null);
  }
}
