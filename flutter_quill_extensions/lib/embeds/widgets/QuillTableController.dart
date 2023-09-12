import 'package:flutter_quill/flutter_quill.dart';

import '../../flutter_quill_extensions.dart';

class QuillTableController extends QuillController {
  QuillTableController({
    required this.parentController,
    required this.index,
    required document,
    required selection,
  }) : super(document: document, selection: selection);

  final QuillController parentController;
  final TableIndex index;
}
