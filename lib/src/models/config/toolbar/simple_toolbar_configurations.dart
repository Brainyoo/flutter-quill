import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/widgets.dart'
    show Axis, Color, Decoration, WrapAlignment, WrapCrossAlignment;

import '../../../widgets/quill/embeds.dart';
import '../../../widgets/quill/quill_controller.dart';
import '../../structs/link_dialog_action.dart';
import '../../themes/quill_dialog_theme.dart';
import '../../themes/quill_icon_theme.dart';
import '../quill_shared_configurations.dart';
import 'simple_toolbar_button_options.dart';
import 'toolbar_shared_configurations.dart';

export './../../../widgets/toolbar/buttons/search/search_dialog.dart';
export 'base_button_configurations.dart';
export 'buttons/clear_format_configurations.dart';
export 'buttons/color_configurations.dart';
export 'buttons/custom_button_configurations.dart';
export 'buttons/font_family_configurations.dart';
export 'buttons/font_size_configurations.dart';
export 'buttons/history_configurations.dart';
export 'buttons/indent_configurations.dart';
export 'buttons/link_style2_configurations.dart';
export 'buttons/link_style_configurations.dart';
export 'buttons/search_configurations.dart';
export 'buttons/select_alignment_configurations.dart';
export 'buttons/select_header_style_buttons_configurations.dart';
export 'buttons/select_header_style_dropdown_button_configurations.dart';
export 'buttons/toggle_check_list_configurations.dart';
export 'buttons/toggle_style_configurations.dart';
export 'simple_toolbar_button_options.dart';

/// The default size of the icon of a button.
const double kDefaultIconSize = 15;

/// The default size for the toolbar (width, height)
const double kDefaultToolbarSize = kDefaultIconSize * 2;

/// The factor of how much larger the button is in relation to the icon.
const double kDefaultIconButtonFactor = 1.6;

/// The horizontal margin between the contents of each toolbar section.
const double kToolbarSectionSpacing = 4;

enum LinkStyleType {
  /// Defines the original [QuillToolbarLinkStyleButton].
  original,

  /// Defines the alternative [QuillToolbarLinkStyleButton2].
  alternative;

  bool get isOriginal => this == LinkStyleType.original;
  bool get isAlternative => this == LinkStyleType.alternative;
}

enum HeaderStyleType {
  /// Defines the original [QuillToolbarSelectHeaderStyleDropdownButton].
  original,

  /// Defines the alternative [QuillToolbarSelectHeaderStyleButtons].
  buttons;

  bool get isOriginal => this == HeaderStyleType.original;
  bool get isButtons => this == HeaderStyleType.buttons;
}

/// The configurations for the toolbar widget of flutter quill
@immutable
class QuillSimpleToolbarConfigurations extends QuillSharedToolbarProperties {
  const QuillSimpleToolbarConfigurations({
    required this.controller,
    super.sharedConfigurations,
    super.toolbarSectionSpacing = kToolbarSectionSpacing,
    super.toolbarIconAlignment = WrapAlignment.center,
    super.toolbarIconCrossAlignment = WrapCrossAlignment.center,
    super.buttonOptions = const QuillSimpleToolbarButtonOptions(),
    this.customButtons = const [],
    this.fontFamilyValues,
    super.multiRowsDisplay = true,
    this.fontSizesValues,
    this.showDividers = true,
    this.showFontFamily = true,
    this.showFontSize = true,
    this.showBoldButton = true,
    this.showItalicButton = true,
    this.showSmallButton = false,
    this.showUnderLineButton = true,
    this.showStrikeThrough = true,
    this.showInlineCode = true,
    this.showColorButton = true,
    this.showBackgroundColorButton = true,
    this.showClearFormat = true,
    this.showAlignmentButtons = false,
    this.showLeftAlignment = true,
    this.showCenterAlignment = true,
    this.showRightAlignment = true,
    this.showJustifyAlignment = true,
    this.showHeaderStyle = true,
    this.showListNumbers = true,
    this.showListBullets = true,
    this.showListCheck = true,
    this.showCodeBlock = true,
    this.showQuote = true,
    this.showIndent = true,
    this.showLink = true,
    this.showUndo = true,
    this.showRedo = true,
    this.showDirection = false,
    this.showSearchButton = true,
    this.showSubscript = true,
    this.showSuperscript = true,
    this.showClipboardCut = true,
    this.showClipboardCopy = true,
    this.showClipboardPaste = true,
    this.linkStyleType = LinkStyleType.original,
    this.headerStyleType = HeaderStyleType.original,

    /// The decoration to use for the toolbar.
    super.decoration,

    /// Toolbar items to display for controls of embed blocks
    this.embedButtons,
    super.linkDialogAction,

    ///The theme to use for the icons in the toolbar, uses type [QuillIconTheme]
    // this.iconTheme,
    this.dialogTheme,
    super.axis = Axis.horizontal,
    super.color,
    super.sectionDividerColor,
    super.sectionDividerSpace,

    /// By default it will calculated based on the [globalIconSize] from
    /// [base] in [QuillToolbarButtonOptions]
    /// You can change it but the the change only apply if
    /// the [multiRowsDisplay] is false, if [multiRowsDisplay] then the value
    /// will be [kDefaultIconSize] * 2
    super.toolbarSize,
  }) : _toolbarSize = toolbarSize;

  factory QuillSimpleToolbarConfigurations.only({
    required QuillController controller,
    QuillSharedConfigurations sharedConfigurations =
        const QuillSharedConfigurations(),
    double toolbarSectionSpacing = kToolbarSectionSpacing,
    WrapAlignment toolbarIconAlignment = WrapAlignment.center,
    WrapCrossAlignment toolbarIconCrossAlignment = WrapCrossAlignment.center,
    QuillSimpleToolbarButtonOptions buttonOptions = const QuillSimpleToolbarButtonOptions(),
    List<QuillToolbarCustomButtonOptions> customButtons = const [],
    Map<String, String>? fontFamilyValues,
    bool multiRowsDisplay = false,
    Map<String, String>? fontSizesValues,
    bool showDividers = false,
    bool showFontFamily = false,
    bool showFontSize = false,
    bool showBoldButton = false,
    bool showItalicButton = false,
    bool showSmallButton = false,
    bool showUnderLineButton = false,
    bool showStrikeThrough = false,
    bool showInlineCode = false,
    bool showColorButton = false,
    bool showBackgroundColorButton = false,
    bool showClearFormat = false,
    bool showAlignmentButtons = false,
    bool showLeftAlignment = false,
    bool showCenterAlignment = false,
    bool showRightAlignment = false,
    bool showJustifyAlignment = false,
    bool showHeaderStyle = false,
    bool showListNumbers = false,
    bool showListBullets = false,
    bool showListCheck = false,
    bool showCodeBlock = false,
    bool showQuote = false,
    bool showIndent = false,
    bool showLink = false,
    bool showUndo = false,
    bool showRedo = false,
    bool showDirection = false,
    bool showSearchButton = false,
    bool showSubscript = false,
    bool showSuperscript = false,
    LinkStyleType linkStyleType = LinkStyleType.original,

    /// The decoration to use for the toolbar.
    Decoration? decoration,

    /// Toolbar items to display for controls of embed blocks
    List<EmbedButtonBuilder>? embedButtons,
    LinkDialogAction? linkDialogAction,

    ///The theme to use for the icons in the toolbar, uses type [QuillIconTheme]
    // this.iconTheme,
    QuillDialogTheme? dialogTheme,
    Axis axis = Axis.horizontal,
    Color? color,
    Color? sectionDividerColor,
    double? sectionDividerSpace,

    /// By default it will calculated based on the [globalIconSize] from
    /// [base] in [QuillToolbarButtonOptions]
    /// You can change it but the the change only apply if
    /// the [multiRowsDisplay] is false, if [multiRowsDisplay] then the value
    /// will be [kDefaultIconSize] * 2
    double? toolbarSize,
  }) =>
      QuillSimpleToolbarConfigurations(
        controller: controller,
        sharedConfigurations: sharedConfigurations,
        toolbarSectionSpacing: toolbarSectionSpacing,
        toolbarIconAlignment: toolbarIconAlignment,
        toolbarIconCrossAlignment: toolbarIconCrossAlignment,
        buttonOptions: buttonOptions,
        customButtons: customButtons,
        fontFamilyValues: fontFamilyValues,
        multiRowsDisplay: multiRowsDisplay,
        fontSizesValues: fontSizesValues,
        showDividers: showDividers,
        showFontFamily: showFontFamily,
        showFontSize: showFontSize,
        showBoldButton: showBoldButton,
        showItalicButton: showItalicButton,
        showSmallButton: showSmallButton,
        showUnderLineButton: showUnderLineButton,
        showStrikeThrough: showStrikeThrough,
        showInlineCode: showInlineCode,
        showColorButton: showColorButton,
        showBackgroundColorButton: showBackgroundColorButton,
        showClearFormat: showClearFormat,
        showAlignmentButtons: showAlignmentButtons,
        showLeftAlignment: showLeftAlignment,
        showCenterAlignment: showCenterAlignment,
        showRightAlignment: showRightAlignment,
        showJustifyAlignment: showJustifyAlignment,
        showHeaderStyle: showHeaderStyle,
        showListNumbers: showListNumbers,
        showListBullets: showListBullets,
        showListCheck: showListCheck,
        showCodeBlock: showCodeBlock,
        showQuote: showQuote,
        showIndent: showIndent,
        showLink: showLink,
        showUndo: showUndo,
        showRedo: showRedo,
        showDirection: showDirection,
        showSearchButton: showSearchButton,
        showSubscript: showSubscript,
        showSuperscript: showSuperscript,
        linkStyleType: linkStyleType,
        decoration: decoration,
        embedButtons: embedButtons,
        linkDialogAction: linkDialogAction,
        dialogTheme: dialogTheme,
        axis: axis,
        color: color,
        sectionDividerColor: sectionDividerColor,
        sectionDividerSpace: sectionDividerSpace,
        toolbarSize: toolbarSize,
      );

  final double? _toolbarSize;

  /// The toolbar size, by default it will be `baseButtonOptions.iconSize * 2`
  @override
  double get toolbarSize {
    final alternativeToolbarSize = _toolbarSize;
    if (alternativeToolbarSize != null) {
      return alternativeToolbarSize;
    }
    return (buttonOptions.base.iconSize ?? kDefaultIconSize) * 2;
  }

  final Map<String, String>? fontFamilyValues;

  final QuillController controller;

  /// By default it will be
  /// ```dart
  /// {
  ///   'Small'.i18n: 'small',
  ///   'Large'.i18n: 'large',
  ///   'Huge'.i18n: 'huge',
  ///   'Clear'.loc: '0'
  /// }
  /// ```
  final Map<String, String>? fontSizesValues;

  /// List of custom buttons
  final List<QuillToolbarCustomButtonOptions> customButtons;

  final bool showDividers;
  final bool showFontFamily;
  final bool showFontSize;
  final bool showBoldButton;
  final bool showItalicButton;
  final bool showSmallButton;
  final bool showUnderLineButton;
  final bool showStrikeThrough;
  final bool showInlineCode;
  final bool showColorButton;
  final bool showBackgroundColorButton;
  final bool showClearFormat;

  final bool showAlignmentButtons;
  final bool showLeftAlignment;
  final bool showCenterAlignment;
  final bool showRightAlignment;
  final bool showJustifyAlignment;
  final bool showHeaderStyle;
  final bool showListNumbers;
  final bool showListBullets;
  final bool showListCheck;
  final bool showCodeBlock;
  final bool showQuote;
  final bool showIndent;
  final bool showLink;
  final bool showUndo;
  final bool showRedo;
  final bool showDirection;
  final bool showSearchButton;
  final bool showSubscript;
  final bool showSuperscript;
  final bool showClipboardCut;
  final bool showClipboardCopy;
  final bool showClipboardPaste;

  /// Toolbar items to display for controls of embed blocks
  final List<EmbedButtonBuilder>? embedButtons;

  // ///The theme to use for the icons in the toolbar, uses type [QuillIconTheme]
  // final QuillIconTheme? iconTheme;

  ///The theme to use for the theming of the [LinkDialog()],
  ///shown when embedding an image, for example
  final QuillDialogTheme? dialogTheme;

  /// Defines which dialog is used for applying link attribute.
  final LinkStyleType linkStyleType;

  /// Defines which dialog is used for applying header attribute.
  final HeaderStyleType headerStyleType;

  @override
  List<Object?> get props => [
        buttonOptions,
        multiRowsDisplay,
        fontSizesValues,
        toolbarSize,
        axis,
      ];
}
