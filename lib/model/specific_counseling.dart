class SpecificCounseling {
  final int? idSpecificCounseling;
  final int idDayOfCounseling;
  final String? extras;
  final String? topic;
  final DateTime date;
  final String? name;
  final String? day;
  final int? idModule_start;
  final int? idModule_end;
  final List<String>? advisorsNames;
  final List<String> advisorsKeys;

  SpecificCounseling(
      {this.idSpecificCounseling,
      required this.advisorsKeys,
      required this.idDayOfCounseling,
      this.advisorsNames,
      this.idModule_end,
      this.idModule_start,
      this.name,
      this.day,
      this.extras,
      this.topic,
      required this.date});

  factory SpecificCounseling.fromJson(Map<String, dynamic> json) =>
      SpecificCounseling(
          idSpecificCounseling: json['idSpecificCounseling'],
          idDayOfCounseling: json['idDayOfCounseling'],
          date: DateTime.parse(json['date']),
          topic: json['topic'],
          extras: json['extras'],
          advisorsKeys: json['advisorsKeys']);
  Map<String, dynamic> toJson() => {
        'idSpecificCounseling': idSpecificCounseling,
        'idDayOfCounseling': idDayOfCounseling,
        'date': date.toIso8601String(),
        'topic': topic,
        'extras': extras,
        'advisorsKeys': advisorsKeys,
      };
}
