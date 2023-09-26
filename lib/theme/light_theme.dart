import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

HexColor mainColor = HexColor("#80004a");
HexColor bgColor = HexColor("#F8F2F5");
HexColor secundaryColor = HexColor("#FCB9B2");
HexColor informationColor = HexColor("#253D5B");
HexColor extrasColor = HexColor("#488286");
HexColor mainTextColor = HexColor("#80004a");
HexColor secundaryTextColor = HexColor("#000000");
HexColor disabledColor = HexColor("#d0d0d0");
HexColor pendingColor = HexColor("#D55672");
HexColor acceptedColor = HexColor("#0DAB3F");

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: bgColor,
  primaryColor: mainColor,
  disabledColor: disabledColor,
  focusColor: mainTextColor,
  hoverColor: mainColor,
  iconTheme: IconThemeData(color: mainTextColor),
  highlightColor: secundaryColor,
  secondaryHeaderColor: extrasColor,
  indicatorColor: informationColor,
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
