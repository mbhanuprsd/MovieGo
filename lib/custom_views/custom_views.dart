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
  int get maxLines => maximumLines == null ? super.maxLines : maximumLines;

  @override
  TextOverflow get overflow =>
      maximumLines == null ? super.overflow : TextOverflow.ellipsis;
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating(
      {this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: new List.generate(
        starCount,
        (index) => buildStar(context, index),
      ),
    );
  }
}
