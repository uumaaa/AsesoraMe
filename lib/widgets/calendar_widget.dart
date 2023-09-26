import 'package:asispnia/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {
  const CalendarView(
      {super.key,
      required this.width,
      required this.height,
      required this.fontSize,
      required this.refreshData,
      required this.dateController});
  final double width;
  final double height;
  final double fontSize;
  final Function() refreshData;
  final TextEditingController dateController;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    DateTime currentDate = DateTime.now();
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextField(
        textAlign: TextAlign.center,
        cursorColor: Theme.of(context).hintColor,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Theme.of(context).iconTheme.color!),
          ),
          suffixIconColor: Theme.of(context).iconTheme.color!,
          suffixIcon: Icon(
            CupertinoIcons.calendar_today,
            size: responsive.dp(1.8),
          ),
          hintText: 'Selecciona',
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: responsive.dp(2),
              color: Theme.of(context).hintColor),
        ),
        controller: widget.dateController,
        readOnly: true,
        onTap: () async {
          DateTime? pickdate = await showDatePicker(
            context: context,
            initialDate: currentDate,
            firstDate:
                DateTime(currentDate.year, currentDate.month, currentDate.day),
            lastDate: DateTime(
                currentDate.year, currentDate.month + 5, currentDate.day),
            confirmText: 'Aceptar',
            cancelText: 'Cancelar',
            helpText: 'Selecciona una fecha',
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                      surface: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(context).primaryColor,
                      primary: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).iconTheme.color!
                          : Theme.of(context).scaffoldBackgroundColor,
                      onPrimary:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor,
                      onSurface: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).iconTheme.color!
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    dialogBackgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context).primaryColor,
                    textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color!
                              : Theme.of(context).scaffoldBackgroundColor,
                    ))),
                child: child!,
              );
            },
          );
          if (pickdate == null) {
            return;
          } else {
            if (pickdate.month <= 9) {
              widget.dateController.text =
                  '${pickdate.year}-0${pickdate.month}-${pickdate.day}';
              widget.refreshData();
            } else {
              widget.dateController.text =
                  '${pickdate.year}-${pickdate.month}-${pickdate.day}';
              widget.refreshData();
            }
          }
        },
      ),
    );
  }
}
