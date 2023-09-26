class Achievement {
  final String name;
  final String description;
  final String url;
  final int points;
  Achievement(
    this.name,
    this.description,
    this.points,
    this.url,
  );

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
      json["name"], json["description"], json["points"], json["url"]);

  Map<String, dynamic> toJson() =>
      {"name": name, "description": description, "points": points, "url": url};
}

List<Achievement> achievementsFromJson(List<dynamic> json) {
  return List<Achievement>.from(json.map((e) => Achievement.fromJson(e)));
}

List<Map<String, dynamic>> achievementsToJson(List<Achievement> data) =>
    List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));
