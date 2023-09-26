import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/logs.dart';

List<Day> daysFromJson(List<dynamic> json) {
  return List<Day>.from(json.map((e) => Day.fromJson(e)));
}

List<Map<String, dynamic>> daysToJson(List<Day> data) =>
    List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

class Day {
  final String day;
  final int idModuleStart;
  final int idModuleEnd;
  final int? idDay;
  final bool confirmed;
  final String? idAdvisor;

  Day(
      {required this.day,
      required this.idModuleStart,
      required this.idModuleEnd,
      this.idAdvisor,
      this.idDay,
      required this.confirmed});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
        day: json['day'],
        idModuleStart: json['idModule_start'],
        idModuleEnd: json['idModule_end'],
        idDay: json['idDay'],
        confirmed: json['confirmed'] == 0 ? false : true,
        idAdvisor: json['idAdvisor']);
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'idModule_start': idModuleStart,
        'idModule_end': idModuleEnd,
        'idDay': idDay,
        'confirmed': confirmed,
        'idAdvisor': idAdvisor
      };
  @override
  String toString() {
    return '$day, $idModuleStart, $idModuleEnd,$confirmed,$idAdvisor';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }
    if (o.runtimeType != runtimeType) {
      return false;
    }
    return o is Day && o.day == day;
  }
}
