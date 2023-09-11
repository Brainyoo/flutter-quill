library flutter_quill_extensions;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'embeds/builders.dart';
import 'embeds/embed_types.dart';
import 'embeds/toolbar/audio_button.dart';
import 'embeds/toolbar/camera_button.dart';
import 'embeds/toolbar/formula_button.dart';
import 'embeds/toolbar/image_button.dart';
import 'embeds/toolbar/video_button.dart';

export 'embeds/builders.dart';
export 'embeds/embed_types.dart';
export 'embeds/toolbar/camera_button.dart';
export 'embeds/toolbar/formula_button.dart';
export 'embeds/toolbar/image_button.dart';
export 'embeds/toolbar/image_video_audio_utils.dart';
export 'embeds/toolbar/media_button.dart';
export 'embeds/toolbar/video_button.dart';
export 'embeds/utils.dart';

class FlutterQuillEmbeds {
  static List<EmbedBuilder> builders({
    void Function(GlobalKey videoContainerKey)? onVideoInit,
  }) =>
      [
        ImageEmbedBuilder(),
        VideoEmbedBuilder(onVideoInit: onVideoInit),
        FormulaEmbedBuilder(),
        AudioEmbedBuilder(),
      ];

  static List<EmbedBuilder> webBuilders() => [
        ImageEmbedBuilderWeb(),
      ];

  static List<EmbedButtonBuilder> buttons({
    bool showImageButton = true,
    bool showVideoButton = true,
    bool showCameraButton = true,
    bool showAudioButton = true,
    bool showFormulaButton = false,
    String? imageButtonTooltip,
    String? videoButtonTooltip,
    String? audioButtonTooltip,
    String? cameraButtonTooltip,
    String? formulaButtonTooltip,
    OnImagePickCallback? onImagePickCallback,
    OnVideoPickCallback? onVideoPickCallback,
    OnAudioPickCallback? onAudioPickCallback,
    MediaPickSettingSelector? mediaPickSettingSelector,
    MediaPickSettingSelector? cameraPickSettingSelector,
    FilePickImpl? filePickImpl,
    WebImagePickImpl? webImagePickImpl,
    WebVideoPickImpl? webVideoPickImpl,
    WebImagePickImpl? webAudioPickImpl,
    RegExp? imageLinkRegExp,
    RegExp? videoLinkRegExp,
    RegExp? audioLinkRegExp,
  }) =>
      [
        if (showImageButton)
          (controller, toolbarButtonSize, toolbarIconSize, iconTheme,
                  dialogTheme) =>
              ImageButton(
                icon: Icons.image,
                iconSize: toolbarIconSize,
                buttonSize: toolbarIconSize,
                tooltip: imageButtonTooltip,
                controller: controller,
                onImagePickCallback: onImagePickCallback,
                filePickImpl: filePickImpl,
                webImagePickImpl: webImagePickImpl,
                mediaPickSettingSelector: mediaPickSettingSelector,
                iconTheme: iconTheme,
                dialogTheme: dialogTheme,
                linkRegExp: imageLinkRegExp,
              ),
        if (showVideoButton)
          (controller, toolbarButtonSize, toolbarIconSize, iconTheme,
                  dialogTheme) =>
              VideoButton(
                icon: Icons.movie_creation,
                iconSize: toolbarIconSize,
                buttonSize: toolbarIconSize,
                tooltip: videoButtonTooltip,
                controller: controller,
                onVideoPickCallback: onVideoPickCallback,
                filePickImpl: filePickImpl,
                webVideoPickImpl: webImagePickImpl,
                mediaPickSettingSelector: mediaPickSettingSelector,
                iconTheme: iconTheme,
                dialogTheme: dialogTheme,
                linkRegExp: videoLinkRegExp,
              ),
        if ((onImagePickCallback != null || onVideoPickCallback != null) &&
            showCameraButton)
          (controller, toolbarButtonSize, toolbarIconSize, iconTheme,
                  dialogTheme) =>
              CameraButton(
                icon: Icons.photo_camera,
                iconSize: toolbarIconSize,
                buttonSize: toolbarIconSize,
                tooltip: cameraButtonTooltip,
                controller: controller,
                onImagePickCallback: onImagePickCallback,
                onVideoPickCallback: onVideoPickCallback,
                filePickImpl: filePickImpl,
                webImagePickImpl: webImagePickImpl,
                webVideoPickImpl: webVideoPickImpl,
                cameraPickSettingSelector: cameraPickSettingSelector,
                iconTheme: iconTheme,
              ),
        if (showAudioButton)
          (controller, toolbarButtonSize, toolbarIconSize, iconTheme,
                  dialogTheme) =>
              AudioButton(
                icon: Icons.mic,
                iconSize: toolbarIconSize,
                buttonSize: toolbarIconSize,
                tooltip: audioButtonTooltip,
                controller: controller,
                onAudioPickCallback: onAudioPickCallback,
                filePickImpl: filePickImpl,
                webAudioPickImpl: webAudioPickImpl,
                mediaPickSettingSelector: mediaPickSettingSelector,
                iconTheme: iconTheme,
                dialogTheme: dialogTheme,
                linkRegExp: audioLinkRegExp,
              ),
        if (showFormulaButton)
          (controller, toolbarButtonSize, toolbarIconSize, iconTheme,
                  dialogTheme) =>
              FormulaButton(
                icon: Icons.functions,
                iconSize: toolbarIconSize,
                buttonSize: toolbarIconSize,
                tooltip: formulaButtonTooltip,
                controller: controller,
                iconTheme: iconTheme,
                dialogTheme: dialogTheme,
              )
      ];
}
