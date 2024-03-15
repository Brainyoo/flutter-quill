class QuillShortcutConfiguration {
  const QuillShortcutConfiguration({
    this.enableHideSelectionToolbar = true,
    this.enableUndo = true,
    this.enableRedo = true,
    this.enableBold = true,
    this.enableUnderline = true,
    this.enableItalic = true,
    this.enableStrikeThrough = true,
    this.enableInlineCode = true,
    this.enableCodeBlock = true,
    this.enableBlockQuote = true,
    this.enableLink = true,
    this.enableUnorderedList = true,
    this.enableOrderedList = true,
    this.enableCheckList = true,
    this.enableIndent = true,
    this.enableH1 = true,
    this.enableH2 = true,
    this.enableH3 = true,
    this.enableH4 = true,
    this.enableH5 = true,
    this.enableH6 = true,
    this.enableHeaderReset = true,
    this.enableImage = true,
    this.enableSearch = true,
  });

  const QuillShortcutConfiguration.disabled()
      : this(
          enableHideSelectionToolbar: false,
          enableUndo: false,
          enableRedo: false,
          enableBold: false,
          enableUnderline: false,
          enableItalic: false,
          enableStrikeThrough: false,
          enableInlineCode: false,
          enableCodeBlock: false,
          enableBlockQuote: false,
          enableLink: false,
          enableUnorderedList: false,
          enableOrderedList: false,
          enableCheckList: false,
          enableIndent: false,
          enableH1: false,
          enableH2: false,
          enableH3: false,
          enableH4: false,
          enableH5: false,
          enableH6: false,
          enableHeaderReset: false,
          enableImage: false,
          enableSearch: false,
        );

  final bool enableHideSelectionToolbar;
  final bool enableUndo;
  final bool enableRedo;
  final bool enableBold;
  final bool enableUnderline;
  final bool enableItalic;
  final bool enableStrikeThrough;
  final bool enableInlineCode;
  final bool enableCodeBlock;
  final bool enableBlockQuote;
  final bool enableLink;
  final bool enableUnorderedList;
  final bool enableOrderedList;
  final bool enableCheckList;
  final bool enableIndent;
  final bool enableH1;
  final bool enableH2;
  final bool enableH3;
  final bool enableH4;
  final bool enableH5;
  final bool enableH6;
  final bool enableHeaderReset;
  final bool enableImage;
  final bool enableSearch;
}
