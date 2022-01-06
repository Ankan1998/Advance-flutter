import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final String buttonURL;
  final Function onPressed;
  final Color bgColor;
  final EdgeInsets padding;
  final bool isDisabled;
  final TextStyle textStyle;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final double height;
  final double width;
  final bool expandHorizontally;
  final BorderRadiusGeometry customBorder;
  final double buttonWidth;
  final Color disabledStateBgColor;

  const CustomTextButton({
    Key key,
    @required this.title,
    this.buttonURL,
    this.onPressed,
    this.bgColor,
    this.padding,
    this.textStyle,
    this.isDisabled: false,
    this.borderRadius =20.0,
    this.borderColor = Colors.white,
    this.borderWidth = 1.0,
    this.height = 32.0,
    this.width = 120.0,
    this.expandHorizontally = false,
    this.customBorder,
    this.buttonWidth,
    this.disabledStateBgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = isDisabled
        ? Colors.grey[300]
        : Colors.blue;
    return GestureDetector(
      child: Container(
        width: buttonWidth,
        padding: padding != null
            ? padding
            : EdgeInsets.symmetric(
            vertical: 12, horizontal: expandHorizontally ? 0 : 52),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: borderColor,
              width:borderWidth
          ),
          borderRadius: customBorder == null
              ? (borderRadius == null
              ? 0
              : BorderRadius.all(Radius.circular(borderRadius)))
              : customBorder,
        ),
        child: (expandHorizontally)
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                title,
                textAlign: TextAlign.center,
                style: textStyle
            )
          ],
        )
            : Text(
            title,
            textAlign: TextAlign.center,
            style: textStyle
        ),
      ),
      onTap: (isDisabled)
          ? null
          : () {
        if (!isDisabled && buttonURL != null) {
          Navigator.pushNamed(context, buttonURL);
        } else if (onPressed != null) {
          onPressed();
        }
      },
    );
  }
}