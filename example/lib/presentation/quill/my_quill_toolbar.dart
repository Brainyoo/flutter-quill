import 'dart:io' as io show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/extensions.dart' show isAndroid, isIOS, isWeb;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import '../../embeds/cloze/cloze_embed_builder.dart';
import '../settings/cubit/settings_cubit.dart';
import 'embeds/timestamp_embed.dart';

class MyQuillToolbar extends StatelessWidget {
  const MyQuillToolbar({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  final QuillController controller;
  final FocusNode focusNode;

  Future<void> onImageInsertWithCropping(
    String image,
    QuillController controller,
    BuildContext context,
  ) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    final newImage = croppedFile?.path;
    if (newImage == null) {
      return;
    }
    if (isWeb()) {
      controller.insertImageBlock(imageSource: newImage);
      return;
    }
    final newSavedImage = await saveImage(io.File(newImage));
    controller.insertImageBlock(imageSource: newSavedImage);
  }

  Future<void> onImageInsert(String image, QuillController controller) async {
    if (isWeb() || isHttpBasedUrl(image)) {
      controller.insertImageBlock(imageSource: image);
      return;
    }
    final newSavedImage = await saveImage(io.File(image));
    controller.insertImageBlock(imageSource: newSavedImage);
  }

  /// For mobile platforms it will copies the picked file from temporary cache
  /// to applications directory
  ///
  /// for desktop platforms, it will do the same but from user files this time
  Future<String> saveImage(io.File file) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final fileExt = path.extension(file.path);
    final newFileName = '${DateTime.now().toIso8601String()}$fileExt';
    final newPath = path.join(
      appDocDir.path,
      newFileName,
    );
    final copiedFile = await file.copy(newPath);
    return copiedFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.useCustomQuillToolbar != current.useCustomQuillToolbar,
      builder: (context, state) {
        if (state.useCustomQuillToolbar) {
          // For more info
          // https://github.com/singerdmx/flutter-quill/blob/master/doc/custom_toolbar.md
          return QuillToolbar(
            configurations: const QuillToolbarConfigurations(
              buttonOptions: QuillToolbarButtonOptions(
                base: QuillToolbarBaseButtonOptions(
                  globalIconSize: 20,
                  globalIconButtonFactor: 1.4,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context
                        .read<SettingsCubit>()
                        .updateSettings(
                            state.copyWith(useCustomQuillToolbar: false)),
                    icon: const Icon(
                      Icons.width_normal,
                    ),
                  ),
                  QuillToolbarHistoryButton(
                    isUndo: true,
                    controller: controller,
                  ),
                  QuillToolbarHistoryButton(
                    isUndo: false,
                    controller: controller,
                  ),
                  QuillToolbarToggleStyleButton(
                    options: const QuillToolbarToggleStyleButtonOptions(),
                    controller: controller,
                    attribute: Attribute.bold,
                  ),
                  QuillToolbarToggleStyleButton(
                    options: const QuillToolbarToggleStyleButtonOptions(),
                    controller: controller,
                    attribute: Attribute.italic,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.underline,
                  ),
                  QuillToolbarClearFormatButton(
                    controller: controller,
                  ),
                  const VerticalDivider(),
                  QuillToolbarImageButton(
                    controller: controller,
                  ),
                  QuillToolbarCameraButton(
                    controller: controller,
                  ),
                  QuillToolbarVideoButton(
                    controller: controller,
                  ),
                  const VerticalDivider(),
                  QuillToolbarColorButton(
                    controller: controller,
                    isBackground: false,
                  ),
                  QuillToolbarColorButton(
                    controller: controller,
                    isBackground: true,
                  ),
                  const VerticalDivider(),
                  QuillToolbarSelectHeaderStyleButton(
                    controller: controller,
                  ),
                  const VerticalDivider(),
                  QuillToolbarToggleCheckListButton(
                    controller: controller,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.ol,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.ul,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.inlineCode,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.blockQuote,
                  ),
                  QuillToolbarIndentButton(
                    controller: controller,
                    isIncrease: true,
                  ),
                  QuillToolbarIndentButton(
                    controller: controller,
                    isIncrease: false,
                  ),
                  const VerticalDivider(),
                  QuillToolbarLinkStyleButton(controller: controller),
                ],
              ),
            ),
          );
        }
        return QuillSimpleToolbar(
          configurations: QuillSimpleToolbarConfigurations(
            controller: controller,
            showAlignmentButtons: true,
            buttonOptions: QuillToolbarButtonOptions(
              base: QuillToolbarBaseButtonOptions(
                // Request editor focus when any button is pressed
                afterButtonPressed: focusNode.requestFocus,
              ),
            ),
            customButtons: [
              QuillToolbarCustomButtonOptions(
                icon: const Icon(Icons.space_bar_outlined),
                onPressed: () => _addEditCloze(context),
              ),
              QuillToolbarCustomButtonOptions(
                icon: const Icon(Icons.add_alarm_rounded),
                onPressed: () {
                  controller.document
                      .insert(controller.selection.extentOffset, '\n');
                  controller.updateSelection(
                    TextSelection.collapsed(
                      offset: controller.selection.extentOffset + 1,
                    ),
                    ChangeSource.local,
                  );

                  controller.document.insert(
                    controller.selection.extentOffset,
                    TimeStampEmbed(
                      DateTime.now().toString(),
                    ),
                  );

                  controller.updateSelection(
                    TextSelection.collapsed(
                      offset: controller.selection.extentOffset + 1,
                    ),
                    ChangeSource.local,
                  );

                  controller.document
                      .insert(controller.selection.extentOffset, ' ');
                  controller.updateSelection(
                    TextSelection.collapsed(
                      offset: controller.selection.extentOffset + 1,
                    ),
                    ChangeSource.local,
                  );

                  controller.document
                      .insert(controller.selection.extentOffset, '\n');
                  controller.updateSelection(
                    TextSelection.collapsed(
                      offset: controller.selection.extentOffset + 1,
                    ),
                    ChangeSource.local,
                  );
                },
              ),
              QuillToolbarCustomButtonOptions(
                icon: const Icon(Icons.dashboard_customize),
                onPressed: () {
                  context.read<SettingsCubit>().updateSettings(
                      state.copyWith(useCustomQuillToolbar: true));
                },
              ),
            ],
            embedButtons: FlutterQuillEmbeds.toolbarButtons(
              imageButtonOptions: QuillToolbarImageButtonOptions(
                imageButtonConfigurations: QuillToolbarImageConfigurations(
                  onImageInsertCallback: isAndroid(supportWeb: false) ||
                          isIOS(supportWeb: false) ||
                          isWeb()
                      ? (image, controller) =>
                          onImageInsertWithCropping(image, controller, context)
                      : onImageInsert,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addEditCloze(BuildContext context, {Document? document}) async {
    final isEditing = document != null;
    final quillEditorController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    final textController = TextEditingController(text: document?.toPlainText());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.only(left: 16, top: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${isEditing ? 'Edit' : 'Add'} cloze'),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            )
          ],
        ),
        content: TextField(
          controller: textController,
        ),
      ),
    );

    quillEditorController.replaceText(0, 0, textController.text, null);

    if (quillEditorController.document.isEmpty()) return;

    quillEditorController.formatText(0, quillEditorController.document.length,
        const IdAttribute('SuperTolleSuperID'));

    final block = BlockEmbed.custom(
      ClozeBlockEmbed.fromDocument(quillEditorController.document),
    );
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    if (isEditing) {
      final offset =
          getEmbedNode(controller, controller.selection.start).offset;
      controller.replaceText(
          offset, 1, block, TextSelection.collapsed(offset: offset));
    } else {
      controller.replaceText(index, length, block, null);
    }
  }
}
