class TableEntity {
  const TableEntity({required this.rows});

  factory TableEntity.withRowCountAndColumnCount(
      int rowCount, int columnCount) {
    final rows = List<TableRowEntity>.generate(
      rowCount,
      (_) => TableRowEntity(
        cells: List.generate(
          columnCount,
          (_) => const TableCellEntity(deltaJson: [
            {'insert': '\n'}
          ]),
        ),
      ),
    );
    return TableEntity(rows: rows);
  }

  factory TableEntity.fromJson(Map<String, dynamic> json) {
    return TableEntity(
      rows: List<TableRowEntity>.from(
        json['rows'].map(
          (row) => TableRowEntity.fromJson(row),
        ),
      ),
    );
  }
  final List<TableRowEntity> rows;

  Map<String, dynamic> toJson() {
    return {
      'rows': rows.map((row) => row.toJson()).toList(),
    };
  }

  TableEntity copyTableWithCellContent(
      int rowIdx, int cellIdx, List<dynamic> content) {
    final newRows = List<TableRowEntity>.from(
        rows); // make a copy of the original rows list
    final row = newRows[rowIdx];
    final newCells = List<TableCellEntity>.from(
        row.cells); // make a copy of the cells list in the selected row
    final newCell = TableCellEntity(deltaJson: content);
    newCells[cellIdx] = newCell;
    final newRow = TableRowEntity(cells: newCells);
    newRows[rowIdx] = newRow;
    return TableEntity(rows: newRows);
  }

  TableEntity copyTableWithAdditionalRow() {
    final newRows = List<TableRowEntity>.from(
        rows); // make a copy of the original rows list
    final newCells = List<TableCellEntity>.generate(
        rows[0].cells.length,
        (_) => const TableCellEntity(deltaJson: [
              {'insert': '\n'}
            ])); // create a list of default cells for the new row
    final newRow = TableRowEntity(cells: newCells);
    newRows.add(newRow);
    return TableEntity(rows: newRows);
  }

  TableEntity copyTableWithAdditionalColumn() {
    final newRows = rows.map((row) {
      final newCells = List<TableCellEntity>.from(row.cells)
        ..add(const TableCellEntity(deltaJson: [
          {'insert': '\n'}
        ])); // add a default cell to the end of the cells list
      return TableRowEntity(cells: newCells);
    }).toList();
    return TableEntity(rows: newRows);
  }
}

class TableRowEntity {
  const TableRowEntity({required this.cells});
  factory TableRowEntity.fromJson(Map<String, dynamic> json) {
    return TableRowEntity(
      cells: List<TableCellEntity>.from(
        json['cells'].map(
          (cell) => TableCellEntity(deltaJson: cell),
        ),
      ),
    );
  }
  final List<TableCellEntity> cells;

  Map<String, dynamic> toJson() {
    return {
      'cells': cells.map((cell) => cell.deltaJson).toList(),
    };
  }
}

class TableCellEntity {
  const TableCellEntity({required this.deltaJson});
  final List<dynamic> deltaJson;
}
