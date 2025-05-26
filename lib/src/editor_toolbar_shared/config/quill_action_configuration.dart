class QuillActionConfiguration {
  const QuillActionConfiguration({
    this.enableDoNothingAndStopPropagationTextIntent = true,
    this.enableReplaceTextIntent = true,
    this.enableUpdateSelectionIntent = true,
    this.enableDirectionalFocusIntent = true,
    this.enableDeleteCharacterIntent = true,
    this.enableDeleteToNextWordBoundaryIntent = true,
    this.enableDeleteToLineBreakIntent = true,
    this.enableExtendSelectionByCharacterIntent = true,
    this.enableExtendSelectionToNextWordBoundaryIntent = true,
    this.enableExtendSelectionToLineBreakIntent = true,
    this.enableExtendSelectionVerticallyToAdjacentLineIntent = true,
    this.enableExtendSelectionToDocumentBoundaryIntent = true,
    this.enableExtendSelectionToNextWordBoundaryOrCaretLocationIntent = true,
    this.enableSelectAllTextIntent = true,
    this.enableCopySelectionTextIntent = true,
    this.enablePasteTextIntent = true,
    this.enableHideSelectionToolbarIntent = true,
    this.enableUndoTextIntent = true,
    this.enableRedoTextIntent = true,
    this.enableOpenSearchIntent = true,
    this.enableToggleTextStyleIntent = true,
    this.enableIndentSelectionIntent = true,
    this.enableApplyHeaderIntent = true,
    this.enableApplyCheckListIntent = true,
    this.enableApplyLinkIntent = true,
    this.enableScrollToDocumentBoundaryIntent = true,
    this.enableExtendSelectionVerticallyToAdjacentPageIntent = true,
    this.enableScrollIntent = true,
    this.enableExpandSelectionToDocumentBoundaryIntent = true,
  });

  const QuillActionConfiguration.disabled() : this.only();

  const QuillActionConfiguration.only({
    bool enableDoNothingAndStopPropagationTextIntent = false,
    bool enableReplaceTextIntent = false,
    bool enableUpdateSelectionIntent = false,
    bool enableDirectionalFocusIntent = false,
    bool enableDeleteCharacterIntent = false,
    bool enableDeleteToNextWordBoundaryIntent = false,
    bool enableDeleteToLineBreakIntent = false,
    bool enableExtendSelectionByCharacterIntent = false,
    bool enableExtendSelectionToNextWordBoundaryIntent = false,
    bool enableExtendSelectionToLineBreakIntent = false,
    bool enableExtendSelectionVerticallyToAdjacentLineIntent = false,
    bool enableExtendSelectionToDocumentBoundaryIntent = false,
    bool enableExtendSelectionToNextWordBoundaryOrCaretLocationIntent = false,
    bool enableSelectAllTextIntent = false,
    bool enableCopySelectionTextIntent = false,
    bool enablePasteTextIntent = false,
    bool enableHideSelectionToolbarIntent = false,
    bool enableUndoTextIntent = false,
    bool enableRedoTextIntent = false,
    bool enableOpenSearchIntent = false,
    bool enableToggleTextStyleIntent = false,
    bool enableIndentSelectionIntent = false,
    bool enableApplyHeaderIntent = false,
    bool enableApplyCheckListIntent = false,
    bool enableApplyLinkIntent = false,
    bool enableScrollToDocumentBoundaryIntent = false,
    bool enableExtendSelectionVerticallyToAdjacentPageIntent = false,
    bool enableScrollIntent = false,
    bool enableExpandSelectionToDocumentBoundaryIntent = false,
  }) : this(
          enableDoNothingAndStopPropagationTextIntent:
              enableDoNothingAndStopPropagationTextIntent,
          enableReplaceTextIntent: enableReplaceTextIntent,
          enableUpdateSelectionIntent: enableUpdateSelectionIntent,
          enableDirectionalFocusIntent: enableDirectionalFocusIntent,
          enableDeleteCharacterIntent: enableDeleteCharacterIntent,
          enableDeleteToNextWordBoundaryIntent:
              enableDeleteToNextWordBoundaryIntent,
          enableDeleteToLineBreakIntent: enableDeleteToLineBreakIntent,
          enableExtendSelectionByCharacterIntent:
              enableExtendSelectionByCharacterIntent,
          enableExtendSelectionToNextWordBoundaryIntent:
              enableExtendSelectionToNextWordBoundaryIntent,
          enableExtendSelectionToLineBreakIntent:
              enableExtendSelectionToLineBreakIntent,
          enableExtendSelectionVerticallyToAdjacentLineIntent:
              enableExtendSelectionVerticallyToAdjacentLineIntent,
          enableExtendSelectionToDocumentBoundaryIntent:
              enableExtendSelectionToDocumentBoundaryIntent,
          enableExtendSelectionToNextWordBoundaryOrCaretLocationIntent:
              enableExtendSelectionToNextWordBoundaryOrCaretLocationIntent,
          enableSelectAllTextIntent: enableSelectAllTextIntent,
          enableCopySelectionTextIntent: enableCopySelectionTextIntent,
          enablePasteTextIntent: enablePasteTextIntent,
          enableHideSelectionToolbarIntent: enableHideSelectionToolbarIntent,
          enableUndoTextIntent: enableUndoTextIntent,
          enableRedoTextIntent: enableRedoTextIntent,
          enableOpenSearchIntent: enableOpenSearchIntent,
          enableToggleTextStyleIntent: enableToggleTextStyleIntent,
          enableIndentSelectionIntent: enableIndentSelectionIntent,
          enableApplyHeaderIntent: enableApplyHeaderIntent,
          enableApplyCheckListIntent: enableApplyCheckListIntent,
          enableApplyLinkIntent: enableApplyLinkIntent,
          enableScrollToDocumentBoundaryIntent:
              enableScrollToDocumentBoundaryIntent,
          enableExtendSelectionVerticallyToAdjacentPageIntent:
              enableExtendSelectionVerticallyToAdjacentPageIntent,
          enableScrollIntent: enableScrollIntent,
          enableExpandSelectionToDocumentBoundaryIntent:
              enableExpandSelectionToDocumentBoundaryIntent,
        );

  final bool enableDoNothingAndStopPropagationTextIntent;
  final bool enableReplaceTextIntent;
  final bool enableUpdateSelectionIntent;
  final bool enableDirectionalFocusIntent;
  final bool enableDeleteCharacterIntent;
  final bool enableDeleteToNextWordBoundaryIntent;
  final bool enableDeleteToLineBreakIntent;
  final bool enableExtendSelectionByCharacterIntent;
  final bool enableExtendSelectionToNextWordBoundaryIntent;
  final bool enableExtendSelectionToLineBreakIntent;
  final bool enableExtendSelectionVerticallyToAdjacentLineIntent;
  final bool enableExtendSelectionToDocumentBoundaryIntent;
  final bool enableExtendSelectionToNextWordBoundaryOrCaretLocationIntent;
  final bool enableSelectAllTextIntent;
  final bool enableCopySelectionTextIntent;
  final bool enablePasteTextIntent;
  final bool enableHideSelectionToolbarIntent;
  final bool enableUndoTextIntent;
  final bool enableRedoTextIntent;
  final bool enableOpenSearchIntent;
  final bool enableToggleTextStyleIntent;
  final bool enableIndentSelectionIntent;
  final bool enableApplyHeaderIntent;
  final bool enableApplyCheckListIntent;
  final bool enableApplyLinkIntent;
  final bool enableScrollToDocumentBoundaryIntent;
  final bool enableExtendSelectionVerticallyToAdjacentPageIntent;
  final bool enableScrollIntent;
  final bool enableExpandSelectionToDocumentBoundaryIntent;
}
