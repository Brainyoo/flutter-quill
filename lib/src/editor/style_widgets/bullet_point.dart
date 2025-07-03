import 'package:flutter/widgets.dart';

class QuillBulletPoint extends StatelessWidget {
  const QuillBulletPoint({
    required this.style,
    required this.width,
    this.padding = 0,
    this.backgroundColor,
    this.textAlign,
    AlignmentDirectional? alignment,
    super.key,
  }) : alignment = alignment ?? AlignmentDirectional.topEnd;

  final TextStyle style;
  final double width;
  final double padding;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: width,
      padding: EdgeInsetsDirectional.only(end: padding),
      color: backgroundColor,
      child: Text(
        '•',
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
