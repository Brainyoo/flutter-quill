import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart';
import '../widgets/video_app.dart';
import '../widgets/youtube_video_app.dart';

class VideoEmbedBuilder implements EmbedBuilder {
  VideoEmbedBuilder({this.onVideoInit});

  final void Function(GlobalKey videoContainerKey)? onVideoInit;

  @override
  String get key => BlockEmbed.videoType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    base.Embed node,
    bool readOnly,
  ) {
    assert(!kIsWeb, 'Please provide video EmbedBuilder for Web');

    final videoUrl = node.value.data;
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      return YoutubeVideoApp(
          videoUrl: videoUrl, context: context, readOnly: readOnly);
    }
    return VideoApp(
      videoUrl: videoUrl,
      context: context,
      readOnly: readOnly,
      onVideoInit: onVideoInit,
    );
  }
}