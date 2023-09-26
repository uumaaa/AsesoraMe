import 'dart:convert';

import 'package:asispnia/model/achievement.dart';

List<Player> playersFromJson(String str) =>
    List<Player>.from(json.decode(str).map((x) => Player.fromJson(x)));

String playersToJson(List<Player> data) =>
    json.encode(List<Map<String, dynamic>>.from(data.map((x) => x.toJson())));

class Player {
  final int points;
  final int level;
  final String idUser;
  final String type;
  final double score;
  final int counselingsCompleted;
  final List<Achievement> achievements;

  Player(
      {required this.counselingsCompleted,
      required this.points,
      required this.level,
      required this.idUser,
      required this.type,
      required this.score,
      required this.achievements});

  factory Player.fromJson(Map<String, dynamic> json) => Player(
      points: json["points"],
      level: json["level"],
      counselingsCompleted: json["counselings_completed"],
      idUser: json["idUser"],
      type: json["type"],
      achievements: achievementsFromJson(json["achievements"]),
      score: double.parse(json["score"].toString()));

  Map<String, dynamic> toJson() => {
        "points": points,
        "level": level,
        "idUser": idUser,
        "type": type,
        "score": score,
        "counselings_completed": counselingsCompleted
      };
}
