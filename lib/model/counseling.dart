import 'package:asispnia/model/day.dart';

import '../utils/logs.dart';

abstract class Counseling {
  final int? idCounseling;
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final String type;
  final List<Day> days;

  Counseling(
      {this.idCounseling,
      required this.name,
      required this.startTime,
      this.endTime,
      required this.days,
      required this.type});

  Map<String, dynamic> toJson() => {};
}

class MainCounseling extends Counseling {
  final List<String>? advisorsNames;
  final List<String> advisorsKeys;

  MainCounseling({
    required super.days,
    this.advisorsNames,
    required this.advisorsKeys,
    super.idCounseling,
    required super.name,
    required super.startTime,
    required super.endTime,
    required super.type,
  });

  factory MainCounseling.fromJson(Map<String, dynamic> json) => MainCounseling(
      idCounseling: json['idCounseling'],
      name: json['name'],
      startTime: DateTime.parse(
        json['start_time'],
      ),
      type: "Asesoria",
      endTime: DateTime.parse(
        json['end_time'],
      ),
      advisorsNames: List<String>.from(json["advisorsNames"]),
      advisorsKeys: List<String>.from(json["advisorsKeys"]),
      days: daysFromJson(json['days']));

  @override
  Map<String, dynamic> toJson() => {
        'idCounseling': idCounseling,
        'name': name,
        'start_time': startTime.toIso8601String(),
        'end_time': startTime.toIso8601String(),
        'type': type,
        'advisorsKeys': advisorsKeys,
        'advisorsNames': advisorsNames,
        'days': daysToJson(days)
      };
}

class ExtraCounseling extends Counseling {
  final int extracurricularCategory;
  final String? extracurricularName;
  final List<String>? advisorsNames;
  final List<String> advisorsKeys;

  ExtraCounseling(
      {this.extracurricularName,
      required this.extracurricularCategory,
      required super.days,
      this.advisorsNames,
      required this.advisorsKeys,
      super.idCounseling,
      required super.name,
      required super.startTime,
      required super.endTime,
      required super.type});

  factory ExtraCounseling.fromJson(Map<String, dynamic> json) =>
      ExtraCounseling(
          idCounseling: json['idCounseling'],
          name: json['name'],
          startTime: DateTime.parse(
            json['start_time'],
          ),
          endTime: DateTime.parse(
            json['end_time'],
          ),
          type: "Actividad extracurricular",
          extracurricularCategory: json['extracurricular_category'],
          extracurricularName: json['extra_name'],
          advisorsNames: List<String>.from(json["advisorsNames"]),
          advisorsKeys: List<String>.from(json["advisorsKeys"]),
          days: daysFromJson(json['days']));
  @override
  Map<String, dynamic> toJson() => {
        'idCounseling': idCounseling,
        'name': name,
        'start_time': startTime.toIso8601String(),
        'end_time': startTime.toIso8601String(),
        'type': type,
        'advisorsKeys': advisorsKeys,
        'advisorsNames': advisorsNames,
        'extra_name': extracurricularName,
        'extracurricular_category': extracurricularCategory,
        'days': daysToJson(days)
      };
}

class PrivateCounseling extends Counseling {
  final String idAdvisedUser;
  final String advisedName;
  final String? advisorName;
  final String? advisorKey;
  final String? topics;
  final Map<String, List<Day>>? requestDays;

  PrivateCounseling(
      {required super.days,
      this.topics,
      this.advisorName,
      this.advisorKey,
      super.idCounseling,
      required super.name,
      required super.startTime,
      super.endTime,
      required super.type,
      this.requestDays,
      required this.idAdvisedUser,
      required this.advisedName});

  factory PrivateCounseling.fromJson(Map<String, dynamic> json) {
    Map<String, List<dynamic>> initialMap = Map.from(json['requestDays']);
    Map<String, List<Day>> finalMap = {};
    List<MapEntry<String, List<dynamic>>> entriesList =
        initialMap.entries.toList();
    for (var i = 0; i < initialMap.length; i++) {
      String mapKey = entriesList[i].key;
      List<dynamic> mapValue = entriesList[i].value;
      finalMap[mapKey] = daysFromJson(mapValue);
    }
    Logs.p.i(finalMap);
    return PrivateCounseling(
        idCounseling: json['idCounseling'],
        name: json['name'],
        startTime: DateTime.parse(
          json['start_time'],
        ),
        endTime: json['end_time'] == null
            ? null
            : DateTime.parse(
                json['end_time'],
              ),
        type: "Privada",
        topics: json['topics'],
        idAdvisedUser: json['idAdvisedUser'],
        advisedName: json['advisedName'],
        advisorName: json["advisorName"],
        advisorKey: json["advisorKey"],
        days: daysFromJson(json['days']),
        requestDays: finalMap);
  }
  @override
  Map<String, dynamic> toJson() => {
        'idCounseling': idCounseling,
        'name': name,
        'start_time': startTime.toIso8601String(),
        'end_time': startTime.toIso8601String(),
        'type': type,
        'advisorKey': advisorKey,
        'advisorName': advisorName,
        'advisedName': advisedName,
        'idAdvisedUser': idAdvisedUser,
        'topics': topics,
        'days': daysToJson(days)
      };

  @override
  String toString() {
    return '$name,$idAdvisedUser,$startTime,$endTime,$days,$topics,';
  }
}
