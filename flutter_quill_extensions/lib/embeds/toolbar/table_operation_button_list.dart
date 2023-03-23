import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../flutter_quill_extensions.dart';
import '../widgets/QuillTableController.dart';

class TableOperationButtonList extends StatelessWidget {
  const TableOperationButtonList({
    required this.axis,
    required this.iconSize,
    required this.buttonSize,
    required this.controller,
    this.fillColor,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  final Axis axis;

  final double iconSize;
  final double buttonSize;

  final Color? fillColor;
  final QuillIconTheme? iconTheme;

  final QuillTableController controller;

  @override
  Widget build(BuildContext context) {
    final children = [
      _TableOperationButton(
        buttonSize: buttonSize,
        iconSize: iconSize,
        icon: Icons.border_left,
        fillColor: fillColor,
        iconTheme: iconTheme,
        onPressed: _addNewColumnBefore,
      ),
      _TableOperationButton(
        buttonSize: buttonSize,
        iconSize: iconSize,
        icon: Icons.border_right,
        fillColor: fillColor,
        iconTheme: iconTheme,
        onPressed: _addNewColumnAfter,
      ),
      _TableOperationButton(
        buttonSize: buttonSize,
        iconSize: iconSize,
        icon: Icons.remove,
        fillColor: fillColor,
        iconTheme: iconTheme,
        onPressed: _removeColumn,
      ),
      _TableOperationButton(
        buttonSize: buttonSize,
        iconSize: iconSize,
        icon: Icons.border_left,
        fillColor: fillColor,
        iconTheme: iconTheme,
        onPressed: _addNewRowAbove,
      ),
      _TableOperationButton(
        buttonSize: buttonSize,
        iconSize: iconSize,
        icon: Icons.border_left,
        fillColor: fillColor,
        iconTheme: iconTheme,
        onPressed: _addNewRowBelow,
      ),
      _TableOperationButton(
        buttonSize: buttonSize,
        iconSize: iconSize,
        icon: Icons.remove,
        fillColor: fillColor,
        iconTheme: iconTheme,
        onPressed: _removeRow,
      ),
    ];

    return axis == Axis.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }

  void _addNewRowAbove() {
    _replaceTable(
      controller,
      (table, index) => table.copyTableWithAdditionalRow(rowIdx: index.row),
    );
  }

  void _addNewRowBelow() {
    _replaceTable(
      controller,
      (table, index) => table.copyTableWithAdditionalRow(rowIdx: index.row + 1),
    );
  }

  void _removeRow() {
    _replaceTable(
      controller,
      (table, index) => table.copyTableWithoutRow(index.row),
    );
  }

  void _addNewColumnBefore() {
    _replaceTable(
      controller,
      (table, index) =>
          table.copyTableWithAdditionalColumn(columnIdx: index.column + 1),
    );
  }

  void _addNewColumnAfter() {
    _replaceTable(
      controller,
      (table, index) =>
          table.copyTableWithAdditionalColumn(columnIdx: index.column + 1),
    );
  }

  void _removeColumn() {
    _replaceTable(
      controller,
      (table, index) => table.copyTableWithoutRow(index.row),
    );
  }

  void _replaceTable(QuillTableController controller,
      TableModel Function(TableModel table, TableIndex index) createTable) {
    final embed = getEmbedNode(controller, controller.selection.start).value;
    final offset = getEmbedNode(controller, controller.selection.start).offset;
    final table = TableModel.fromJson(jsonDecode(embed.value.data));
    final newTable = createTable(table, controller.index);
    final block = BlockEmbed.table(jsonEncode(newTable.toJson()));
    controller.replaceText(
        offset, 1, block, TextSelection.collapsed(offset: offset));
  }
}

class _TableOperationButton extends StatelessWidget {
  const _TableOperationButton({
    required this.icon,
    required this.iconSize,
    required this.buttonSize,
    this.fillColor,
    this.iconTheme,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final double buttonSize;

  final Color? fillColor;
  final QuillIconTheme? iconTheme;
  final VoidCallback? onPressed;

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
      onPressed: onPressed,
    );
  }
}
