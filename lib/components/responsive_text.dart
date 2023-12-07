import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  ResponsiveText(
      {this.text = 'text',
      this.textAlign = TextAlign.left,
      this.style = const TextStyle(fontSize: 14, fontFamily: "DelaGothicOne"),
      Key? key})
      : super(key: key);

  String text;
  TextStyle style;
  TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        text: text,
        style: style,
      ),
    );
  }
}
