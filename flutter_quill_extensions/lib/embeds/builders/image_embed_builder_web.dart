import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:universal_html/html.dart' as html;

import '../../shims/dart_ui_fake.dart'
    if (dart.library.html) '../../shims/dart_ui_real.dart' as ui;

class ImageEmbedBuilderWeb extends EmbedBuilder {
  ImageEmbedBuilderWeb({this.constraints})
      : assert(kIsWeb, 'ImageEmbedBuilderWeb is only for web platform');

  final BoxConstraints? constraints;

  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final imageUrl = node.value.data;

    ui.platformViewRegistry.registerViewFactory(imageUrl, (viewId) {
      return html.ImageElement()
        ..src = imageUrl
        ..style.height = 'auto'
        ..style.width = 'auto';
    });

    return ConstrainedBox(
      constraints: constraints ?? BoxConstraints.loose(const Size(200, 200)),
      child: HtmlElementView(
        viewType: imageUrl,
      ),
    );
  }
}
