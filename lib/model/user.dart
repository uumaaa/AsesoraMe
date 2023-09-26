import 'dart:convert';

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String usersToJson(List<User> data) =>
    json.encode(List<Map<String, dynamic>>.from(data.map((x) => x.toJson())));

class User {
  final String idUser;
  final String name;
  final String username;
  final String type;
  final String mail;

  User(
      {required this.idUser,
      required this.name,
      required this.username,
      required this.type,
      required this.mail});

  static userError() =>
      User(idUser: '-1', name: '', username: '', type: 'none', mail: '');

  factory User.fromJson(Map<String, dynamic> json) => User(
      idUser: json['idUser'],
      name: json['name'],
      username: json['username'],
      type: json['type'],
      mail: json['mail']);

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'username': username,
        'type': type,
        'mail': mail,
      };
}
