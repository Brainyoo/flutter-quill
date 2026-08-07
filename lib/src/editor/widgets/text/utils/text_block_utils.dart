import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../common/structs/horizontal_spacing.dart';
import '../../../../common/structs/vertical_spacing.dart';
import '../../../../document/attribute.dart';
import '../../../../document/nodes/block.dart';
import '../../../../document/nodes/node.dart';
import '../../default_styles.dart';

/// The effective text scale multiplier from the ambient [MediaQuery]
/// (system accessibility scaling composed with
/// [QuillEditorConfig.textScaleFactor]).
double ambientTextScale(BuildContext context) {
  const probe = 16.0;
  return MediaQuery.textScalerOf(context).scale(probe) / probe;
}

/// Scales vertical paragraph/block spacing with the effective text scale so
/// that the layout grows proportionally with the rendered text.
VerticalSpacing scaledVerticalSpacing(
  VerticalSpacing spacing,
  BuildContext context,
) {
  final scale = ambientTextScale(context);
  return scale == 1.0
      ? spacing
      : VerticalSpacing(spacing.top * scale, spacing.bottom * scale);
}

/// Scales a block's horizontal padding with the effective text scale, so the
/// block indent stays in proportion with the rendered text and the vertical
/// spacing (see [scaledVerticalSpacing]).
HorizontalSpacing scaledHorizontalSpacing(
  HorizontalSpacing spacing,
  BuildContext context,
) {
  final scale = ambientTextScale(context);
  return scale == 1.0
      ? spacing
      : HorizontalSpacing(spacing.left * scale, spacing.right * scale);
}

/// Computes the horizontal space reserved for a block's leading (bullet,
/// number, code-block line number).
///
/// The returned width is used as a *tight* constraint for the leading widget
/// (see `RenderEditableTextLine.performLayout`), so it defines the slot the
/// marker has to fit into.
///
/// A custom implementation is responsible for tracking the effective text
/// scale itself — multiply the base font size with
/// `MediaQuery.textScalerOf(context)` the way
/// [TextBlockUtils.defaultIndentWidthBuilder] does. Otherwise the indent stays
/// fixed while the marker glyphs grow with
/// [QuillEditorConfig.textScaleFactor] / the OS accessibility setting, and the
/// markers get clipped.
typedef LeadingBlockIndentWidth =
    HorizontalSpacing Function(
      Block block,
      BuildContext context,
      int count,
      LeadingBlockNumberPointWidth numberPointWidthDelegate,
    );

/// Computes the width of a number point leading for `count` list items.
///
/// Note: `fontSize` is the *already text-scaled* font size, not the raw
/// [DefaultStyles.paragraph] size — both
/// [TextBlockUtils.defaultIndentWidthBuilder] and the leading builder in
/// `EditableTextBlock` apply the ambient [TextScaler] before calling this.
/// Do not scale it a second time.
typedef LeadingBlockNumberPointWidth =
    double Function(double fontSize, int count);

typedef TextSpanBuilder =
    InlineSpan Function(
      BuildContext context,
      Node node,
      int nodeOffset,
      String text,
      TextStyle? style,
      GestureRecognizer? recognizer,
    );

TextSpan defaultSpanBuilder(
  BuildContext context,
  Node node,
  int textOffset,
  String text,
  TextStyle? style,
  GestureRecognizer? recognizer,
) => TextSpan(
  text: text,
  style: style,
  recognizer: recognizer,
  mouseCursor: (recognizer != null) ? SystemMouseCursors.click : null,
);

abstract final class TextBlockUtils {
  /// Get the horizontalSpacing using the default
  /// implementation provided by [Flutter Quill]
  static HorizontalSpacing defaultIndentWidthBuilder(
    Block block,
    BuildContext context,
    int count,
    LeadingBlockNumberPointWidth numberPointWidthBuilder,
  ) {
    final defaultStyles = QuillStyles.getStyles(context, false)!;
    final baseFontSize = defaultStyles.paragraph?.style.fontSize ?? 16;
    // Structural indents must track the effective text scale, otherwise the
    // scaled glyphs get clipped out of their fixed-width slots.
    final fontSize = MediaQuery.textScalerOf(context).scale(baseFontSize);
    final attrs = block.style.attributes;

    final indent = attrs[Attribute.indent.key];
    var extraIndent = 0.0;
    if (indent != null && indent.value != null) {
      extraIndent = fontSize * indent.value;
    }

    if (attrs.containsKey(Attribute.blockQuote.key)) {
      return HorizontalSpacing(fontSize + extraIndent, 0);
    }

    var baseIndent = 0.0;

    if (attrs.containsKey(Attribute.list.key)) {
      baseIndent = fontSize * 2;
      if (attrs[Attribute.list.key] == Attribute.ol) {
        baseIndent = numberPointWidthBuilder(fontSize, count);
      } else if (attrs.containsKey(Attribute.codeBlock.key)) {
        baseIndent = numberPointWidthBuilder(fontSize, count);
      }
    }

    return HorizontalSpacing(baseIndent + extraIndent, 0);
  }

  /// Get the width for the number point leading using the default
  /// implementation provided by [Flutter Quill]
  static double defaultNumberPointWidthBuilder(double fontSize, int count) {
    final length = '$count'.length;
    switch (length) {
      case 1:
      case 2:
        return fontSize * 2;
      default:
        // 3 -> 2.5
        // 4 -> 3
        // 5 -> 3.5
        return fontSize * (length - (length - 2) / 2);
    }
  }
}
