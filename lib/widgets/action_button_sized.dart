import 'package:flutter/material.dart';

class ActionButtonSized extends StatelessWidget {
  const ActionButtonSized(
      {super.key,
      required this.buttonContent,
      required this.function,
      required this.width,
      required this.height,
      required this.fontSize,
      required this.isEnable});
  final String buttonContent;
  final void Function() function;
  final double width;
  final double height;
  final double fontSize;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: isEnable ? function : null,
          child: Container(
            alignment: Alignment.center,
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: isEnable
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.34),
                    blurRadius: 0)
              ],
            ),
            child: Text(buttonContent,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).iconTheme.color
                      : Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                )),
          ),
        ),
      ],
    );
  }
}

class ActionButtonSizedAltColor extends StatelessWidget {
  const ActionButtonSizedAltColor(
      {super.key,
      required this.buttonContent,
      required this.function,
      required this.width,
      required this.height,
      required this.fontSize,
      required this.isEnable});
  final String buttonContent;
  final void Function() function;
  final double width;
  final double height;
  final double fontSize;
  final bool isEnable;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: isEnable ? function : null,
          child: Container(
            alignment: Alignment.center,
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isEnable
                      ? Theme.of(context).primaryColor.withRed(150)
                      : Theme.of(context).disabledColor,
                  width: 3),
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.34),
                    blurRadius: 0)
              ],
            ),
            child: Text(buttonContent,
                style: TextStyle(
                  color: isEnable
                      ? Theme.of(context).primaryColor.withRed(150)
                      : Theme.of(context).disabledColor,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                )),
          ),
        ),
      ],
    );
  }
}
