import 'package:asispnia/model/counseling.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/specific_counseling.dart';

class ExtraInfoView extends StatefulWidget {
  static String routeName = "extra_info_view";
  const ExtraInfoView({super.key, required this.counseling});
  final ExtraCounseling counseling;

  @override
  State<ExtraInfoView> createState() => _ExtraInfoViewState();
}

class _ExtraInfoViewState extends State<ExtraInfoView> {
  final DateTime now = DateTime.now();

  List<SpecificCounseling> generateCounselingDays(ExtraCounseling counseling) {
    String formattedDayOfWeek = DateFormat('EEEE').format(now);
    int day = 7;
    if (formattedDayOfWeek == 'Monday') {
      day = 1;
    }
    if (formattedDayOfWeek == 'Tuesday') {
      day = 2;
    }
    if (formattedDayOfWeek == 'Wednesday') {
      day = 3;
    }
    if (formattedDayOfWeek == 'Thursday') {
      day = 4;
    }
    if (formattedDayOfWeek == 'Friday') {
      day = 5;
    }
    if (formattedDayOfWeek == 'Saturday') {
      day = 6;
    }
    List<SpecificCounseling> toShow = [];
    if (counseling.endTime!.isBefore(DateTime.now())) {
      return [];
    }
    if (counseling.startTime
        .isAfter(DateTime.now().add(const Duration(days: 8)))) {
      return [];
    }
    for (var specificDay in counseling.days) {
      int counselingDay = 7;
      if (specificDay.day == "Lunes") {
        counselingDay = 1;
      }
      if (specificDay.day == "Martes") {
        counselingDay = 2;
      }
      if (specificDay.day == "Miercoles") {
        counselingDay = 3;
      }
      if (specificDay.day == "Jueves") {
        counselingDay = 4;
      }
      if (specificDay.day == "Viernes") {
        counselingDay = 5;
      }
      if (specificDay.day == "Sabado") {
        counselingDay = 6;
      }
      int diff = day - counselingDay;
      if (diff <= 1) {
        toShow.add(SpecificCounseling(
            advisorsNames: counseling.advisorsNames,
            idDayOfCounseling: specificDay.idDay!,
            name: counseling.name,
            day: specificDay.day,
            advisorsKeys: counseling.advisorsKeys,
            idModule_start: specificDay.idModuleStart,
            idModule_end: specificDay.idModuleEnd,
            date: now.add(Duration(days: diff))));
      }
    }
    return toShow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text(widget.counseling.name),
        Text(widget.counseling.days.toString()),
        Text(widget.counseling.advisorsNames.toString()),
        Text(widget.counseling.startTime.toIso8601String()),
        Text(widget.counseling.endTime!.toIso8601String())
      ],
    ));
  }
}
