import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/documents/attribute.dart';
import '../../models/documents/style.dart';
import '../../models/themes/quill_icon_theme.dart';
import '../controller.dart';

class SelectSubSuperScriptButton extends StatefulWidget {
  const SelectSubSuperScriptButton({
    required this.controller,
    required this.buttonSize,
    required this.iconSize,
    this.axis = Axis.horizontal,
    this.iconTheme,
    this.attributes = const [
      Attribute.subscripts,
      Attribute.superscripts,
    ],
    this.afterButtonPressed,
    Key? key,
  }) : super(key: key);

  final QuillController controller;
  final Axis axis;
  final double iconSize;
  final double buttonSize;
  final QuillIconTheme? iconTheme;
  final List<Attribute> attributes;
  final VoidCallback? afterButtonPressed;

  @override
  _SelectSubSuperScriptButtonState createState() =>
      _SelectSubSuperScriptButtonState();
}

class _SelectSubSuperScriptButtonState
    extends State<SelectSubSuperScriptButton> {
  Attribute? _selectedAttribute;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  final _valueToText = <Attribute, IconData>{
    Attribute.subscripts: Icons.text_rotation_angledown,
    Attribute.superscripts: Icons.text_rotation_angleup,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedAttribute = _getValue();
    });
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.attributes.every((element) => _valueToText.keys.contains(element)),
      'All attributes must be one of them: subscripts, superscripts',
    );

    final theme = Theme.of(context);
    final style = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: widget.iconSize * 0.7,
    );

    final children = widget.attributes.map((attribute) {
      final isSelected = _selectedAttribute == attribute;
      return Padding(
        // ignore: prefer_const_constructors
        padding: EdgeInsets.symmetric(horizontal: !kIsWeb ? 1.0 : 5.0),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            width: widget.buttonSize,
            height: widget.buttonSize,
          ),
          child: RawMaterialButton(
            hoverElevation: 0,
            highlightElevation: 0,
            elevation: 0,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(widget.iconTheme?.borderRadius ?? 2)),
            fillColor: isSelected
                ? (widget.iconTheme?.iconSelectedFillColor ??
                    Theme.of(context).colorScheme.primary)
                : (widget.iconTheme?.iconUnselectedFillColor ??
                    theme.canvasColor),
            onPressed: () {
              if (_selectedAttribute != attribute &&
                  _selectedAttribute != null) {
                widget.controller.formatSelection(
                    Attribute.clone(_selectedAttribute!, null));
              }
              widget.controller.formatSelection(_selectedAttribute == attribute
                  ? Attribute.clone(attribute, null)
                  : attribute);
              widget.afterButtonPressed?.call();
            },
            child: Icon(
              _valueToText[attribute] ?? Icons.error,
              color: isSelected
                  ? (widget.iconTheme?.iconSelectedColor ??
                      theme.primaryIconTheme.color)
                  : (widget.iconTheme?.iconUnselectedColor ??
                      theme.iconTheme.color),
            ),
          ),
        ),
      );
    }).toList();

    return widget.axis == Axis.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }

  void _didChangeEditingValue() {
    setState(() {
      _selectedAttribute = _getValue();
    });
  }

  Attribute<dynamic>? _getValue() {
    final superscriptAttr =
        widget.controller.toolbarButtonToggler[Attribute.superscripts.key];
    final subscriptAttr =
        widget.controller.toolbarButtonToggler[Attribute.subscripts.key];

    if (superscriptAttr != null) {
      // checkbox tapping causes controller.selection to go to offset 0
      widget.controller.toolbarButtonToggler.remove(Attribute.superscripts.key);
      return superscriptAttr;
    }
    if (subscriptAttr != null) {
      // checkbox tapping causes controller.selection to go to offset 0
      widget.controller.toolbarButtonToggler.remove(Attribute.subscripts.key);
      return subscriptAttr;
    }
    return _selectionStyle.attributes[Attribute.superscripts.key] ??
        _selectionStyle.attributes[Attribute.subscripts.key];
  }

  @override
  void didUpdateWidget(covariant SelectSubSuperScriptButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _selectedAttribute = _getValue();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }
}
