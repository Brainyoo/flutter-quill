import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../embed_types.dart';
import 'image_video_audio_utils.dart';

class AudioButton extends StatelessWidget {
  const AudioButton({
    required this.icon,
    required this.controller,
    required this.iconSize,
    required this.buttonSize,
    this.onAudioPickCallback,
    this.fillColor,
    this.filePickImpl,
    this.webAudioPickImpl,
    this.mediaPickSettingSelector,
    this.iconTheme,
    this.dialogTheme,
    this.tooltip,
    this.linkRegExp,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final double buttonSize;

  final Color? fillColor;

  final QuillController controller;

  final OnAudioPickCallback? onAudioPickCallback;

  final WebAudioPickImpl? webAudioPickImpl;

  final FilePickImpl? filePickImpl;

  final MediaPickSettingSelector? mediaPickSettingSelector;

  final QuillIconTheme? iconTheme;

  final QuillDialogTheme? dialogTheme;
  final String? tooltip;
  final RegExp? linkRegExp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor =
        iconTheme?.iconUnselectedFillColor ?? (fillColor ?? theme.canvasColor);

    return QuillIconButton(
      icon: Icon(icon, size: iconSize, color: iconColor),
      tooltip: tooltip,
      highlightElevation: 0,
      hoverElevation: 0,
      size: buttonSize,
      fillColor: iconFillColor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      onPressed: () => _onPressedHandler(context),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    if (onAudioPickCallback != null) {
      final selector = mediaPickSettingSelector ??
          ImageAudioVideoUtils.selectMediaPickSetting;
      final source = await selector(context);
      if (source != null) {
        if (source == MediaPickSetting.Gallery) {
          _pickAudio(context);
        } else {
          _typeLink(context);
        }
      }
    } else {
      _typeLink(context);
    }
  }

  void _pickAudio(BuildContext context) =>
      ImageAudioVideoUtils.handleAudioButtonTap(
        context,
        controller,
        onAudioPickCallback!,
        filePickImpl: filePickImpl,
        webAudioPickImpl: webAudioPickImpl,
      );

  void _typeLink(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (_) => LinkDialog(
        dialogTheme: dialogTheme,
        linkRegExp: linkRegExp,
      ),
    ).then(_linkSubmitted);
  }

  void _linkSubmitted(String? value) {
    if (value != null && value.isNotEmpty) {
      final index = controller.selection.baseOffset;
      final length = controller.selection.extentOffset - index;

      controller.replaceText(index, length, BlockEmbed.audio(value), null);
    }
  }
}
