class TableModel {
  const TableModel({required this.rows});

  factory TableModel.withRowCountAndColumnCount(int rowCount, int columnCount) {
    final rows = List<TableRowModel>.generate(
      rowCount,
      (_) => TableRowModel(
        cells: List.generate(
          columnCount,
          (_) => const TableCellModel(deltaJson: [
            {'insert': '\n'}
          ]),
        ),
      ),
    );
    return TableModel(rows: rows);
  }

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      rows: List<TableRowModel>.from(
        json['rows'].map(
          (row) => TableRowModel.fromJson(row),
        ),
      ),
    );
  }
  final List<TableRowModel> rows;

  Map<String, dynamic> toJson() {
    return {
      'rows': rows.map((row) => row.toJson()).toList(),
    };
  }

  TableModel copyTableWithCellContent(
      int rowIdx, int cellIdx, List<dynamic> content) {
    final newRows =
        List<TableRowModel>.from(rows); // make a copy of the original rows list
    final row = newRows[rowIdx];
    final newCells = List<TableCellModel>.from(
        row.cells); // make a copy of the cells list in the selected row
    final newCell = TableCellModel(deltaJson: content);
    newCells[cellIdx] = newCell;
    final newRow = TableRowModel(cells: newCells);
    newRows[rowIdx] = newRow;
    return TableModel(rows: newRows);
  }

  TableModel copyTableWithAdditionalRow({int rowIdx = 0}) {
    final newRows =
        List<TableRowModel>.from(rows); // make a copy of the original rows list
    final newCells = List<TableCellModel>.generate(
        rows[0].cells.length,
        (_) => const TableCellModel(deltaJson: [
              {'insert': '\n'}
            ])); // create a list of default cells for the new row
    final newRow = TableRowModel(cells: newCells);
    newRows.insert(rowIdx, newRow);
    return TableModel(rows: newRows);
  }

  TableModel copyTableWithoutRow(int rowIdx) {
    final newRows = List<TableRowModel>.from(rows)..removeAt(rowIdx);
    return TableModel(rows: newRows);
  }

  TableModel copyTableWithAdditionalColumn({int columnIdx = 0}) {
    final newRows = rows.map((row) {
      final newCells = List<TableCellModel>.from(row.cells)
        ..insert(
            columnIdx,
            const TableCellModel(deltaJson: [
              {'insert': '\n'}
            ])); // add a default cell to the end of the cells list
      return TableRowModel(cells: newCells);
    }).toList();
    return TableModel(rows: newRows);
  }

  TableModel copyTableWithoutColumn(int columnIdx) {
    final newRows = rows.map((row) {
      final newCells = List<TableCellModel>.from(row.cells)
        ..removeAt(columnIdx);
      return TableRowModel(cells: newCells);
    }).toList();
    return TableModel(rows: newRows);
  }
}

class TableRowModel {
  const TableRowModel({required this.cells});
  factory TableRowModel.fromJson(Map<String, dynamic> json) {
    return TableRowModel(
      cells: List<TableCellModel>.from(
        json['cells'].map(
          (cell) => TableCellModel(deltaJson: cell),
        ),
      ),
    );
  }
  final List<TableCellModel> cells;

  Map<String, dynamic> toJson() {
    return {
      'cells': cells.map((cell) => cell.deltaJson).toList(),
    };
  }
}

class TableCellModel {
  const TableCellModel({required this.deltaJson});
  final List<dynamic> deltaJson;
}
