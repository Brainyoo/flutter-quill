import 'package:flutter/widgets.dart';

import '../../document/nodes/leaf.dart' as leaf;
import 'embed_context.dart';

export './embed_context.dart';

abstract class EmbedBuilder {
  const EmbedBuilder();

  String get key;
  bool get expanded => true;

  /// Whether this embed should be visually scaled together with the
  /// surrounding text when a text scale factor is in effect (see
  /// [QuillEditorConfig.textScaleFactor]). Flutter automatically transforms
  /// inline [WidgetSpan]s with the text scaler; set this to `false` for
  /// embeds with a fixed natural size (e.g. video or image players) to
  /// neutralise that transform.
  bool get scaleWithText => true;

  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget);
  }

  String toPlainText(leaf.Embed node) => leaf.Embed.kObjectReplacementCharacter;

  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  );
}

typedef EmbedsBuilder = EmbedBuilder Function(leaf.Embed node);
