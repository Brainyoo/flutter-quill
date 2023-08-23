library flutter_quill_extensions;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'embeds/builders/builders.dart';
import 'embeds/embed_types.dart';
import 'embeds/toolbar/camera_button.dart';
import 'embeds/toolbar/formula_button.dart';
import 'embeds/toolbar/image_button.dart';
import 'embeds/toolbar/table_button.dart';
import 'embeds/toolbar/table_operation_button_list.dart';
import 'embeds/toolbar/video_button.dart';
import 'embeds/widgets/QuillTableController.dart';

export 'embeds/builders/builders.dart';
export 'embeds/embed_types.dart';
export 'embeds/models/models.dart';
export 'embeds/toolbar/camera_button.dart';
export 'embeds/toolbar/formula_button.dart';
export 'embeds/toolbar/image_button.dart';
export 'embeds/toolbar/image_video_utils.dart';
export 'embeds/toolbar/media_button.dart';
export 'embeds/toolbar/video_button.dart';
export 'embeds/utils.dart';
export 'embeds/widgets/QuillTableController.dart';

class FlutterQuillEmbeds {
  static List<EmbedBuilder> builders({
    void Function(GlobalKey videoContainerKey)? onVideoInit,
  }) =>
      [
        ImageEmbedBuilder(),
        VideoEmbedBuilder(onVideoInit: onVideoInit),
        FormulaEmbedBuilder(),
      ];

  static List<EmbedBuilder> webBuilders() => [
        ImageEmbedBuilderWeb(),
      ];

  static List<EmbedButtonBuilder> buttons({
    bool showImageButton = true,
    bool showVideoButton = true,
    bool showCameraButton = true,
    bool showFormulaButton = false,
    bool showTableButton = false,
    bool showTableOperationButtons = false,
    String? imageButtonTooltip,
    String? videoButtonTooltip,
    String? cameraButtonTooltip,
    String? formulaButtonTooltip,
    OnImagePickCallback? onImagePickCallback,
    OnVideoPickCallback? onVideoPickCallback,
    MediaPickSettingSelector? mediaPickSettingSelector,
    MediaPickSettingSelector? cameraPickSettingSelector,
    FilePickImpl? filePickImpl,
    WebImagePickImpl? webImagePickImpl,
    WebVideoPickImpl? webVideoPickImpl,
    RegExp? imageLinkRegExp,
    RegExp? videoLinkRegExp,
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
              ),
        if (showTableButton)
          (controller, toolbarButtonSize, toolbarIconSize, iconTheme,
                  dialogTheme) =>
              TableButton(
                icon: Icons.border_all,
                iconSize: toolbarIconSize,
                buttonSize: toolbarButtonSize,
                controller: controller,
                iconTheme: iconTheme,
              ),
        if (showTableOperationButtons)
          (controller, toolbarButtonSize, toolbarIconSize, iconTheme,
                  dialogTheme) =>
              TableOperationButtonList(
                axis: Axis.horizontal,
                iconSize: toolbarIconSize,
                buttonSize: toolbarButtonSize,
                controller: controller as QuillTableController,
                iconTheme: iconTheme,
              ),
      ];
}
