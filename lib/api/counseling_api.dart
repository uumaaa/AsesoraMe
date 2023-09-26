import 'package:asispnia/data/authentication_client.dart';
import 'package:asispnia/helpers/http.dart';
import 'package:asispnia/model/counseling.dart';
import 'package:asispnia/model/extra_category.dart';
import 'package:get_it/get_it.dart';

import '../data/enum_lists.dart';
import '../model/http_response.dart';

class CounselingApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  String baseAPI = GetIt.instance<String>();

  CounselingApi(this._http, this._authenticationClient);

  Future<HttpResponse<MainCounseling>> getMainCounselingByID(int id) async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<MainCounseling>(
      "${baseAPI}counselings/main/$id/all-data",
      method: "GET",
      headers: {'token': token},
      parser: (data) => MainCounseling.fromJson(data),
    );
  }

  Future<HttpResponse<List<int>>> getMainCounselings() async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<List<int>>(
      "${baseAPI}counselings/main",
      method: "GET",
      headers: {'token': token},
      parser: (data) => List.from(data['idCounselings']),
    );
  }

  Future<HttpResponse<ExtraCounseling>> getExtraCounselingByID(int id) async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<ExtraCounseling>(
      "${baseAPI}counselings/extra/$id/all-data",
      method: "GET",
      headers: {'token': token},
      parser: (data) => ExtraCounseling.fromJson(data),
    );
  }

  Future<HttpResponse<List<int>>> getExtraCounselings() async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<List<int>>(
      "${baseAPI}counselings/extra",
      method: "GET",
      headers: {'token': token},
      parser: (data) => List.from(data['idCounselings']),
    );
  }

  Future<HttpResponse<List<int>>> getPrivateCounselingsUser(String id) async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<List<int>>(
      "${baseAPI}counselings/private/$id",
      method: "GET",
      headers: {'token': token},
      parser: (data) => List.from(data['idCounselings']),
    );
  }

  Future<HttpResponse<List<int>>> getPrivateCounselings() async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<List<int>>(
      "${baseAPI}counselings/private",
      method: "GET",
      headers: {'token': token},
      parser: (data) => List.from(data['idCounselings']),
    );
  }

  Future<HttpResponse<List<int>>> getPrivateCounselingsMine() async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<List<int>>(
      "${baseAPI}counselings/private/advising/me",
      method: "GET",
      headers: {'token': token},
      parser: (data) => List.from(data['idCounselings']),
    );
  }

  Future<HttpResponse<PrivateCounseling>> getPrivateCounselingByID(
      int id) async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<PrivateCounseling>(
      "${baseAPI}counselings/private/$id/all-data",
      method: "GET",
      headers: {'token': token},
      parser: (data) => PrivateCounseling.fromJson(data),
    );
  }

  Future<HttpResponse<List<ExtracurricularCategory>>> getCategories() async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<List<ExtracurricularCategory>>(
      "${baseAPI}extracurricular",
      method: "GET",
      headers: {'token': token},
      parser: (data) => extraCategoriesFromJson(data),
    );
  }

  Future<HttpResponse<Map<String, dynamic>>> postDays(
      Map<String, dynamic> data) async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<Map<String, dynamic>>(
      "${baseAPI}counselings/private/days",
      method: "POST",
      data: data,
      headers: {'token': token},
    );
  }

  Future<HttpResponse<bool>> verifyPreviousRequests(
      String idAdvisor, int idCounseling) async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<bool>(
      "${baseAPI}counselings/private/$idCounseling/days",
      method: "GET",
      data: {"idAdvisor": idAdvisor},
      headers: {'token': token},
    );
  }

  Future<HttpResponse<bool>> acceptCounseling(
      String idAdvisor, int idCounseling) async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<bool>(
      "${baseAPI}counselings/private/$idCounseling/days",
      method: "POST",
      data: {"idAdvisor": idAdvisor},
      headers: {'token': token},
    );
  }

  Future<HttpResponse<bool>> endCounseling(
      int idCounseling, String end_time, PrivateCounseling counseling) async {
    final String? token = await _authenticationClient.accesToken;
    Map<String, dynamic> map = counseling.toJson();
    map["end_time"] = end_time;
    return _http.request<bool>(
      "${baseAPI}counselings/private/$idCounseling/end",
      method: "PUT",
      data: map,
      headers: {'token': token},
    );
  }

  Future<HttpResponse<Map<String, dynamic>>> postCounseling<T>(
      T counseling) async {
    final String? token = await _authenticationClient.accesToken;
    if (counseling is ExtraCounseling) {
      return _http.request<Map<String, dynamic>>(
        "${baseAPI}counselings/extra",
        method: "POST",
        data: counseling.toJson(),
        headers: {'token': token},
      );
    }
    if (counseling is MainCounseling) {
      return _http.request<Map<String, dynamic>>(
        "${baseAPI}counselings/main",
        method: "POST",
        data: counseling.toJson(),
        headers: {'token': token},
      );
    }
    if (counseling is PrivateCounseling) {
      return _http.request<Map<String, dynamic>>(
        "${baseAPI}counselings/private",
        method: "POST",
        data: counseling.toJson(),
        headers: {'token': token},
      );
    }
    return _http.request<Map<String, dynamic>>(
      "${baseAPI}counselings/extra",
      method: "POST",
      data: {},
      headers: {'token': token},
    );
  }
}
