import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart';
import '../widgets/audio.dart';

class AudioEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.audioType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    base.Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return Audio(audioUrl: node.value.data);
  }
}
