import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

HexColor mainColor = HexColor("#66003C");
HexColor bgColor = HexColor("#1B0112");
HexColor secundaryColor = HexColor("#C89892");
HexColor informationColor = HexColor("#18273A");
HexColor extrasColor = HexColor("#2D4D4D");
HexColor mainTextColor = HexColor("#ECE8ED");
HexColor secundaryTextColor = HexColor("#8b8b8b");
HexColor disabledColor = HexColor("#3A4041");
HexColor pendingColor = HexColor("#D55672");
HexColor acceptedColor = HexColor("#0DAB3F");

ThemeData darktTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: bgColor,
  primaryColor: mainColor,
  disabledColor: disabledColor,
  focusColor: mainTextColor,
  hoverColor: mainColor,
  iconTheme: IconThemeData(color: mainTextColor),
  highlightColor: secundaryColor,
  indicatorColor: informationColor,
  secondaryHeaderColor: extrasColor,
  hintColor: secundaryTextColor,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: mainColor),
    backgroundColor: mainColor,
    actionsIconTheme: IconThemeData(color: mainTextColor),
  ),
  cardColor: acceptedColor,
  progressIndicatorTheme: ProgressIndicatorThemeData(
      color: acceptedColor, linearTrackColor: pendingColor),
);
