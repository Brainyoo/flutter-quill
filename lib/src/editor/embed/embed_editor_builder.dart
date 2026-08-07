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
  ///
  /// Only has an effect when [expanded] is `false`. An expanded embed is
  /// rendered as a plain widget rather than an inline [WidgetSpan], so
  /// Flutter never applies the automatic transform to it and there is
  /// nothing to neutralise — such an embed is never scaled with the text,
  /// regardless of this value. Override [expanded] to `false` if you need
  /// the embed to follow the text scale.
  ///
  /// Note that the editor always renders inline embeds with the ambient
  /// text scaler disabled ([MediaQuery.withNoTextScaling]), because the
  /// automatic [WidgetSpan] transform already applies it — text inside the
  /// embed would otherwise grow quadratically. A builder that reads
  /// `MediaQuery.textScalerOf` itself therefore always sees no scaling and
  /// has to derive its own sizing from the [EmbedContext.textStyle] instead.
  bool get scaleWithText => true;

  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget);
  }

  String toPlainText(leaf.Embed node) => leaf.Embed.kObjectReplacementCharacter;

  Widget build(BuildContext context, EmbedContext embedContext);
}

typedef EmbedsBuilder = EmbedBuilder Function(leaf.Embed node);
