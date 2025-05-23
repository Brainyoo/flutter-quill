import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../../../flutter_quill.dart';
import '../../../common/utils/platform.dart';
import 'editor_keyboard_shortcut_actions.dart';

final _isDesktopMacOS = isMacOS;

@internal
Map<SingleActivator, Intent> defaultSinlgeActivatorIntents(
    QuillShortcutConfiguration shortCutConfig) {
  return {
    if (shortCutConfig.enableHideSelectionToolbar)
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): const HideSelectionToolbarIntent(),
    if (shortCutConfig.enableUndo)
      SingleActivator(
        LogicalKeyboardKey.keyZ,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const UndoTextIntent(SelectionChangedCause.keyboard),
    if (shortCutConfig.enableRedo)
      SingleActivator(
        LogicalKeyboardKey.keyY,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const RedoTextIntent(SelectionChangedCause.keyboard),

    // Selection formatting.
    if (shortCutConfig.enableBold)
      SingleActivator(
        LogicalKeyboardKey.keyB,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ToggleTextStyleIntent(Attribute.bold),
    if (shortCutConfig.enableUnderline)
      SingleActivator(
        LogicalKeyboardKey.keyU,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ToggleTextStyleIntent(Attribute.underline),
    if (shortCutConfig.enableItalic)
      SingleActivator(
        LogicalKeyboardKey.keyI,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ToggleTextStyleIntent(Attribute.italic),
    if (shortCutConfig.enableStrikeThrough)
      SingleActivator(
        LogicalKeyboardKey.keyS,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.strikeThrough),
    if (shortCutConfig.enableInlineCode)
      SingleActivator(
        LogicalKeyboardKey.backquote,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ToggleTextStyleIntent(Attribute.inlineCode),
    if (shortCutConfig.enableCodeBlock)
      SingleActivator(
        LogicalKeyboardKey.tilde,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.codeBlock),
    if (shortCutConfig.enableBlockQuote)
      SingleActivator(
        LogicalKeyboardKey.keyB,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.blockQuote),
    if (shortCutConfig.enableLink)
      SingleActivator(
        LogicalKeyboardKey.keyK,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyLinkIntent(),

    // Lists
    if (shortCutConfig.enableUnorderedList)
      SingleActivator(
        LogicalKeyboardKey.keyL,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.ul),
    if (shortCutConfig.enableOrderedList)
      SingleActivator(
        LogicalKeyboardKey.keyO,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const ToggleTextStyleIntent(Attribute.ol),
    if (shortCutConfig.enableCheckList)
      SingleActivator(
        LogicalKeyboardKey.keyC,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const QuillEditorApplyCheckListIntent(),

    // Indents
    if (shortCutConfig.enableIndent)
      SingleActivator(
        LogicalKeyboardKey.keyM,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const IndentSelectionIntent(true),
    if (shortCutConfig.enableIndent)
      SingleActivator(
        LogicalKeyboardKey.keyM,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
        shift: true,
      ): const IndentSelectionIntent(false),

    // Headers
    if (shortCutConfig.enableH1)
      SingleActivator(
        LogicalKeyboardKey.digit1,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h1),
    if (shortCutConfig.enableH2)
      SingleActivator(
        LogicalKeyboardKey.digit2,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h2),
    if (shortCutConfig.enableH3)
      SingleActivator(
        LogicalKeyboardKey.digit3,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h3),
    if (shortCutConfig.enableH4)
      SingleActivator(
        LogicalKeyboardKey.digit4,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h4),
    if (shortCutConfig.enableH5)
      SingleActivator(
        LogicalKeyboardKey.digit5,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h5),
    if (shortCutConfig.enableH6)
      SingleActivator(
        LogicalKeyboardKey.digit6,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.h6),
    if (shortCutConfig.enableH1)
      SingleActivator(
        LogicalKeyboardKey.digit0,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorApplyHeaderIntent(Attribute.header),
    if (shortCutConfig.enableImage)
      SingleActivator(
        LogicalKeyboardKey.keyG,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const QuillEditorInsertEmbedIntent(Attribute.image),
    if (shortCutConfig.enableSearch)
      SingleActivator(
        LogicalKeyboardKey.keyF,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const OpenSearchIntent(),

    //  Arrow key scrolling
    if (shortCutConfig.enableArrowScrolling) ...{
      SingleActivator(
        LogicalKeyboardKey.arrowUp,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ScrollIntent(direction: AxisDirection.up),
      SingleActivator(
        LogicalKeyboardKey.arrowDown,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ScrollIntent(direction: AxisDirection.down),
      SingleActivator(
        LogicalKeyboardKey.pageUp,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ScrollIntent(
          direction: AxisDirection.up, type: ScrollIncrementType.page),
      SingleActivator(
        LogicalKeyboardKey.pageDown,
        control: !_isDesktopMacOS,
        meta: _isDesktopMacOS,
      ): const ScrollIntent(
          direction: AxisDirection.down, type: ScrollIncrementType.page),
    },
  };
}
