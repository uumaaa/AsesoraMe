import 'package:asispnia/helpers/authentication_response.dart';
import 'package:asispnia/helpers/http.dart';
import 'package:asispnia/model/http_response.dart';
import 'package:asispnia/utils/logs.dart';
import 'package:get_it/get_it.dart';
import '../data/enum_lists.dart';
import '../model/user.dart';

class AuthentificationApi {
  final userAPI = 'users/';
  final loginAPI = 'login/';
  final refreshTokenAPI = 'refresh-token/';
  final Http _http;
  String baseAPI = GetIt.instance<String>();

  AuthentificationApi(this._http);

  //get

  //delete
  //post
  Future<HttpResponse<Map<String, dynamic>>> registerUser(
      User user, String password) {
    Map<String, dynamic> data = user.toJson();
    data['password'] = password;
    return _http.request<Map<String, dynamic>>('$baseAPI$userAPI',
        data: data, method: "POST");
  }

  Future<HttpResponse<bool>> verifyPassword(String id, String password) {
    Logs.p.i('$baseAPI$userAPI$id');
    return _http.request<bool>(
      '$baseAPI$userAPI$id',
      method: "GET",
      data: {"password": password},
    );
  }

  Future<HttpResponse<AuthenticationResponse>> getToken(String mail) {
    Map<String, dynamic> data = {"mail": mail};
    return _http.request<AuthenticationResponse>(
      '$baseAPI$loginAPI',
      data: data,
      method: "POST",
      parser: (p0) => AuthenticationResponse.fromJson(p0),
    );
  }

  //Extras
  Future<HttpResponse<String>> getQRApi(String uri) {
    return _http.request<String>(uri);
  }

  Future<HttpResponse<AuthenticationResponse>> refreshToken(
      String expiredToken) {
    return _http.request<AuthenticationResponse>(
      '$baseAPI$refreshTokenAPI',
      method: "POST",
      headers: {"refreshtoken": expiredToken},
      parser: (p0) => AuthenticationResponse.fromJson(p0),
    );
  }
}
