import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../../../flutter_quill.dart';
import '../../../common/utils/platform.dart';
import 'editor_keyboard_shortcut_actions.dart';

final _isDesktopMacOS = isMacOS;

@internal
Map<SingleActivator, Intent> defaultSinlgeActivatorIntents(
    QuillActionConfiguration actionConfiguration) {
  return {
    if (actionConfiguration.enableHideSelectionToolbarIntent)
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): const HideSelectionToolbarIntent(),
    if (actionConfiguration.enableUndoTextIntent)
      SingleActivator(
        LogicalKeyboardKey.keyZ,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const UndoTextIntent(SelectionChangedCause.keyboard),
    if (actionConfiguration.enableRedoTextIntent)
      SingleActivator(
        LogicalKeyboardKey.keyY,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const RedoTextIntent(SelectionChangedCause.keyboard),

    // Selection formatting.
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.keyB,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ToggleTextStyleIntent(Attribute.bold),
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.keyU,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ToggleTextStyleIntent(Attribute.underline),
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.keyI,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ToggleTextStyleIntent(Attribute.italic),
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.keyS,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.strikeThrough),
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.backquote,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ToggleTextStyleIntent(Attribute.inlineCode),
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.tilde,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.codeBlock),
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.keyB,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.blockQuote),
    if (actionConfiguration.enableApplyLinkIntent)
      SingleActivator(
        LogicalKeyboardKey.keyK,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyLinkIntent(),

    // Lists
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.keyL,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.ul),
    if (actionConfiguration.enableToggleTextStyleIntent)
      SingleActivator(
        LogicalKeyboardKey.keyO,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.ol),
    if (actionConfiguration.enableApplyCheckListIntent)
      SingleActivator(
        LogicalKeyboardKey.keyC,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const QuillEditorApplyCheckListIntent(),

    // Indents
    if (actionConfiguration.enableIndentSelectionIntent)
      SingleActivator(
        LogicalKeyboardKey.keyM,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const IndentSelectionIntent(true),
    if (actionConfiguration.enableIndentSelectionIntent)
      SingleActivator(
        LogicalKeyboardKey.keyM,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const IndentSelectionIntent(false),

    // Headers
    if (actionConfiguration.enableApplyHeaderIntent)
      SingleActivator(
        LogicalKeyboardKey.digit1,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h1),
    if (actionConfiguration.enableApplyHeaderIntent)
      SingleActivator(
        LogicalKeyboardKey.digit2,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h2),
    if (actionConfiguration.enableApplyHeaderIntent)
      SingleActivator(
        LogicalKeyboardKey.digit3,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h3),
    if (actionConfiguration.enableApplyHeaderIntent)
      SingleActivator(
        LogicalKeyboardKey.digit4,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h4),
    if (actionConfiguration.enableApplyHeaderIntent)
      SingleActivator(
        LogicalKeyboardKey.digit5,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h5),
    if (actionConfiguration.enableApplyHeaderIntent)
      SingleActivator(
        LogicalKeyboardKey.digit6,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h6),
    if (actionConfiguration.enableApplyHeaderIntent)
      SingleActivator(
        LogicalKeyboardKey.digit0,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.header),
    SingleActivator(
      LogicalKeyboardKey.keyG,
      control: !_isDesktopMacOS,
      meta: _isDesktopMacOS,
    ): const QuillEditorInsertEmbedIntent(Attribute.image),

    if (actionConfiguration.enableOpenSearchIntent)
      SingleActivator(
        LogicalKeyboardKey.keyF,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const OpenSearchIntent(),

    //  Arrow key scrolling
    if (actionConfiguration.enableScrollIntent)
      SingleActivator(
        LogicalKeyboardKey.arrowUp,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ScrollIntent(direction: AxisDirection.up),
    if (actionConfiguration.enableScrollIntent)
      SingleActivator(
        LogicalKeyboardKey.arrowDown,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ScrollIntent(direction: AxisDirection.down),
    if (actionConfiguration.enableScrollIntent)
      SingleActivator(
        LogicalKeyboardKey.pageUp,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ScrollIntent(
          direction: AxisDirection.up, type: ScrollIncrementType.page),
    if (actionConfiguration.enableScrollIntent)
      SingleActivator(
        LogicalKeyboardKey.pageDown,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ScrollIntent(
          direction: AxisDirection.down, type: ScrollIncrementType.page),
  };
}
