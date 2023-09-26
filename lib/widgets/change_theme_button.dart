import 'package:asispnia/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:provider/provider.dart';

class ChangeThemeButton extends StatefulWidget {
  const ChangeThemeButton({super.key});

  @override
  State<ChangeThemeButton> createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.isDarkMode;
    return CupertinoButton(
        child: Icon(
          isDark ? CupertinoIcons.sun_max : CupertinoIcons.moon,
          color: isDark
              ? Theme.of(context).iconTheme.color
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        onPressed: () {
          setState(() {
            isDark = !isDark;
          });
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(isDark);
        });
  }
}


/*    return Switch.adaptive(
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
        });*/