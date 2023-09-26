import 'dart:convert';

List<ExtracurricularCategory> extraCategoriesFromJson(List<dynamic> json) =>
    List<ExtracurricularCategory>.from(
        json.map((e) => ExtracurricularCategory.fromJson(e)));

String extraCategoriesToJson(List<ExtracurricularCategory> data) =>
    json.encode(List<Map<String, dynamic>>.from(data.map((x) => x.toJson())));

class ExtracurricularCategory {
  final int idCategory;
  final String name;

  ExtracurricularCategory({required this.idCategory, required this.name});

  factory ExtracurricularCategory.fromJson(Map<String, dynamic> json) =>
      ExtracurricularCategory(
        idCategory: json['idCategory'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'idCategory': idCategory,
        'name': name,
      };
}
