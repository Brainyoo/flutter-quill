import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../models/table_model.dart';

class TableEmbedBuilder implements EmbedBuilder {
  TableEmbedBuilder({this.onFocusChange});

  final void Function(QuillController controller)? onFocusChange;

  @override
  String get key => 'tableEmbed';

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
  ) {
    final tableData = jsonDecode(node.value.data) as Map<String, dynamic>;
    final table = TableModel.fromJson(tableData);
    final rowWidgets = <TableRow>[];

    for (var rowIndex = 0; rowIndex < table.rows.length; rowIndex++) {
      final row = table.rows[rowIndex];
      final cellWidgets = <Widget>[];
      for (var cellIndex = 0; cellIndex < (row.cells.length); cellIndex++) {
        final cell = row.cells[cellIndex];
        cellWidgets.add(
          _EditorTableCell(
            onChanged: (doc) {
              final newTable = table.copyTableWithCellContent(
                  rowIndex, cellIndex, doc.toDelta().toJson());
              final newJson = jsonEncode(newTable.toJson());
              final offset =
                  getEmbedNode(controller, controller.selection.start).offset;

              controller.replaceText(offset, 1, BlockEmbed.table(newJson),
                  TextSelection.collapsed(offset: offset),
                  ignoreFocus: true);
            },
            initialDocument: Document.fromJson(cell.deltaJson),
            onFocusChange: onFocusChange,
          ),
        );
      }
      rowWidgets.add(TableRow(children: cellWidgets));
    }

    return Material(
        color: Colors.transparent,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Table(
              border: TableBorder.all(),
              children: rowWidgets,
            )));
  }
}

class _EditorTableCell extends StatefulWidget {
  _EditorTableCell({
    required this.onChanged,
    required this.initialDocument,
    this.onFocusChange,
  });

  final void Function(Document document) onChanged;
  final void Function(QuillController controller)? onFocusChange;

  final Document initialDocument;
  final FocusNode focusNode = FocusNode();

  @override
  State<_EditorTableCell> createState() => _EditorTableCellState();
}

class _EditorTableCellState extends State<_EditorTableCell> {
  late final QuillController controller;

  void _handleOnChanged() {
    widget.onChanged(controller.document);
  }

  void _handleFocusChanged() {
    if (widget.onFocusChange != null) {
      widget.onFocusChange!(controller);
    }
  }

  @override
  void didUpdateWidget(covariant _EditorTableCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      widget.focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void initState() {
    super.initState();
    controller = QuillController(
        document: widget.initialDocument,
        selection: const TextSelection.collapsed(offset: 0));
    widget.focusNode.addListener(_handleOnChanged);
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    controller
      ..removeListener(_handleOnChanged)
      ..removeListener(_handleFocusChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: QuillEditor(
        scrollController: ScrollController(),
        scrollable: false,
        autoFocus: false,
        controller: controller,
        expands: false,
        focusNode: widget.focusNode,
        padding: const EdgeInsets.all(4),
        readOnly: false,
      ),
    );
  }
}
