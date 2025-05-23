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
    this.enableArrowScrolling = true,
  });

  const QuillShortcutConfiguration.disabled() : this.only();

  const QuillShortcutConfiguration.only({
    bool enableHideSelectionToolbar = false,
    bool enableUndo = false,
    bool enableRedo = false,
    bool enableBold = false,
    bool enableUnderline = false,
    bool enableItalic = false,
    bool enableStrikeThrough = false,
    bool enableInlineCode = false,
    bool enableCodeBlock = false,
    bool enableBlockQuote = false,
    bool enableLink = false,
    bool enableUnorderedList = false,
    bool enableOrderedList = false,
    bool enableCheckList = false,
    bool enableIndent = false,
    bool enableH1 = false,
    bool enableH2 = false,
    bool enableH3 = false,
    bool enableH4 = false,
    bool enableH5 = false,
    bool enableH6 = false,
    bool enableHeaderReset = false,
    bool enableImage = false,
    bool enableSearch = false,
    bool enableArrowScrolling = false,
  }) : this(
          enableHideSelectionToolbar: enableHideSelectionToolbar,
          enableUndo: enableUndo,
          enableRedo: enableRedo,
          enableBold: enableBold,
          enableUnderline: enableUnderline,
          enableItalic: enableItalic,
          enableStrikeThrough: enableStrikeThrough,
          enableInlineCode: enableInlineCode,
          enableCodeBlock: enableCodeBlock,
          enableBlockQuote: enableBlockQuote,
          enableLink: enableLink,
          enableUnorderedList: enableUnorderedList,
          enableOrderedList: enableOrderedList,
          enableCheckList: enableCheckList,
          enableIndent: enableIndent,
          enableH1: enableH1,
          enableH2: enableH2,
          enableH3: enableH3,
          enableH4: enableH4,
          enableH5: enableH5,
          enableH6: enableH6,
          enableHeaderReset: enableHeaderReset,
          enableImage: enableImage,
          enableSearch: enableSearch,
          enableArrowScrolling: enableArrowScrolling,
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
  final bool enableArrowScrolling;
}
