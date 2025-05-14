import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../common/utils/element_utils/element_web_utils.dart';
import '../../common/utils/web/web.dart';
import 'config/video_web_config.dart';

class QuillEditorWebVideoEmbedBuilder extends EmbedBuilder {
  const QuillEditorWebVideoEmbedBuilder({
    required this.config,
  });

  final QuillEditorWebVideoEmbedConfig config;

  @override
  String get key => BlockEmbed.videoType;

  @override
  bool get expanded => false;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final videoUrl = embedContext.node.value.data;

    final (height, width, margin, alignment) =
        getWebElementAttributes(embedContext.node);

    createHtmlIFrameElement(
      src: videoUrl,
      width: width,
      height: height,
      margin: margin,
      alignSelf: alignment,
    );

    return SizedBox(
      height: 500,
      child: HtmlElementView(
        viewType: videoUrl,
      ),
    );
  }
}
