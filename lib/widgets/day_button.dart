import 'package:asispnia/utils/responsive.dart';

import 'package:flutter/material.dart';

import '../data/enum_lists.dart';
import 'dialogs.dart';

class DayButton extends StatefulWidget {
  const DayButton(
      {super.key,
      required this.selected,
      required this.width,
      required this.height,
      required this.letter,
      required this.number,
      required this.callbackFunction});
  final double width;
  final double height;
  final int number;
  final bool selected;
  final String letter;
  final Function(List<int>) callbackFunction;

  @override
  State<DayButton> createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return GestureDetector(
      onTap: () async {
        await Dialogs.selectModules(context,
            title: "Selecciona los modulos",
            callbackFunction: widget.callbackFunction);
      },
      child: Container(
        width: widget.width,
        margin: EdgeInsets.symmetric(horizontal: responsive.wp(.4)),
        height: widget.height,
        decoration: BoxDecoration(
            color: widget.selected
                ? Theme.of(context).secondaryHeaderColor
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            NAMEOFDAYS[widget.number][0],
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).scaffoldBackgroundColor,
                fontSize: responsive.dp(4),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DayButtonRestricted extends StatefulWidget {
  const DayButtonRestricted(
      {super.key,
      required this.width,
      required this.height,
      required this.number,
      required this.selected,
      required this.letter,
      required this.callbackFunction,
      required this.isEnabled,
      required this.firstModules,
      required this.lastModules});
  final double width;
  final double height;
  final int number;
  final bool selected;
  final String letter;
  final Function(List<int>) callbackFunction;
  final bool isEnabled;
  final List<int> firstModules;
  final List<int> lastModules;

  @override
  State<DayButtonRestricted> createState() => _DayButtonRestrictedState();
}

class _DayButtonRestrictedState extends State<DayButtonRestricted> {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return GestureDetector(
      onTap: widget.isEnabled
          ? () async {
              await Dialogs.selectModulesRestricted(context,
                  title: "Selecciona los modulos",
                  callbackFunction: widget.callbackFunction,
                  firstModules: widget.firstModules,
                  lastModules: widget.lastModules);
            }
          : null,
      child: Container(
        width: widget.width,
        margin: EdgeInsets.symmetric(horizontal: responsive.wp(.4)),
        height: widget.height,
        decoration: BoxDecoration(
            color: widget.isEnabled
                ? widget.selected
                    ? Theme.of(context).secondaryHeaderColor
                    : Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            NAMEOFDAYS[widget.number][0],
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).scaffoldBackgroundColor,
                fontSize: responsive.dp(4),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DayButtonWoutLogic extends StatefulWidget {
  final double width;
  final double height;
  final int number;
  final Function(bool) callBackFunction;
  final bool selected;
  const DayButtonWoutLogic(
      {super.key,
      required this.width,
      required this.height,
      required this.number,
      required this.callBackFunction,
      required this.selected});

  @override
  State<DayButtonWoutLogic> createState() => _DayButtonWoutLogicState();
}

class _DayButtonWoutLogicState extends State<DayButtonWoutLogic> {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return GestureDetector(
      onTap: () {
        widget.callBackFunction(!widget.selected);
      },
      child: Container(
        width: widget.width,
        margin: EdgeInsets.symmetric(horizontal: responsive.wp(.4)),
        height: widget.height,
        decoration: BoxDecoration(
            color: widget.selected
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            NAMEOFDAYS[widget.number][0],
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).scaffoldBackgroundColor,
                fontSize: responsive.dp(4),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
