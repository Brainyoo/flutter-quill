import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

@immutable
class SimpleScreenArgs {
  const SimpleScreenArgs({required this.document});

  final Document document;
}

class SimpleScreen extends StatefulWidget {
  const SimpleScreen({required this.args, super.key});

  final SimpleScreenArgs args;

  static const routeName = '/simple';

  @override
  State<SimpleScreen> createState() => _SimpleScreenState();
}

class _SimpleScreenState extends State<SimpleScreen> {
  final _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    _controller.document = widget.args.document;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations.only(
              controller: _controller,
              showBoldButton: true,
            ),
          ),
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
