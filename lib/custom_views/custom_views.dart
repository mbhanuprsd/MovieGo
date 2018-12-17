import 'package:flutter/material.dart';

class CustomProgress extends CircularProgressIndicator {
  final BuildContext context;
  CustomProgress(this.context);
  @override
  Animation<Color> get valueColor =>
      new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor);
}

class CustomText extends Text {
  final double size;
  final bool isBold;
  final Color textColor;
  final int maximumLines;

  CustomText(
      String data, this.size, this.isBold, this.textColor, this.maximumLines)
      : super(data);

  @override
  TextStyle get style => TextStyle(
      fontSize: size,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: textColor);

  @override
  int get maxLines => maximumLines;

  @override
  TextOverflow get overflow => TextOverflow.ellipsis;
}
