import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Neutralises the automatic [WidgetSpan] text-scale transform that Flutter's
/// paragraph layer applies (see `_AutoScaleInlineWidget` in the framework):
/// the outer transform lays the child out against `maxWidth / scale` and
/// paints it scaled by `scale`; this widget does the exact inverse so the net
/// effect is the embed's natural size in both layout and paint.
class InverseTextScale extends SingleChildRenderObjectWidget {
  const InverseTextScale({required this.scale, super.child, super.key});

  final double scale;

  @override
  RenderInverseTextScale createRenderObject(BuildContext context) =>
      RenderInverseTextScale(scale);

  @override
  void updateRenderObject(
          BuildContext context, RenderInverseTextScale renderObject) =>
      renderObject.scale = scale;
}

class RenderInverseTextScale extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderInverseTextScale(this._scale);

  double _scale;
  double get scale => _scale;
  set scale(double value) {
    if (value == _scale) return;
    assert(value > 0 && value.isFinite);
    _scale = value;
    markNeedsLayout();
  }

  final LayerHandle<TransformLayer> _transformLayer =
      LayerHandle<TransformLayer>();

  Matrix4 get _paintTransform =>
      Matrix4.diagonal3Values(1 / scale, 1 / scale, 1);

  BoxConstraints _childConstraints(BoxConstraints constraints) =>
      BoxConstraints(
        maxWidth: constraints.maxWidth.isFinite
            ? constraints.maxWidth * scale
            : double.infinity,
      );

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_childConstraints(constraints), parentUsesSize: true);
    size = constraints.constrain(child.size / scale);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final childSize =
        child?.getDryLayout(_childConstraints(constraints)) ?? Size.zero;
    return constraints.constrain(childSize / scale);
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      (child?.getMinIntrinsicWidth(height * scale) ?? 0) / scale;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      (child?.getMaxIntrinsicWidth(height * scale) ?? 0) / scale;

  @override
  double computeMinIntrinsicHeight(double width) =>
      (child?.getMinIntrinsicHeight(width * scale) ?? 0) / scale;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      (child?.getMaxIntrinsicHeight(width * scale) ?? 0) / scale;

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final distance = child?.getDistanceToActualBaseline(baseline);
    return distance == null ? null : distance / scale;
  }

  @override
  double? computeDryBaseline(
      covariant BoxConstraints constraints, TextBaseline baseline) {
    final distance =
        child?.getDryBaseline(_childConstraints(constraints), baseline);
    return distance == null ? null : distance / scale;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;
    if (scale == 1.0) {
      context.paintChild(child, offset);
      return;
    }
    _transformLayer.layer = context.pushTransform(
      needsCompositing,
      offset,
      _paintTransform,
      (context, offset) => context.paintChild(child, offset),
      oldLayer: _transformLayer.layer,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null) return false;
    return result.addWithPaintTransform(
      transform: _paintTransform,
      position: position,
      hitTest: (result, position) =>
          child.hitTest(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) =>
      transform.multiply(_paintTransform);

  @override
  void dispose() {
    _transformLayer.layer = null;
    super.dispose();
  }
}
