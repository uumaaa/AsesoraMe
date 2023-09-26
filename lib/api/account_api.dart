import 'package:asispnia/data/authentication_client.dart';
import 'package:asispnia/data/enum_lists.dart';
import 'package:asispnia/helpers/http.dart';
import 'package:get_it/get_it.dart';

import '../model/http_response.dart';
import '../model/user.dart';
import '../utils/logs.dart';

class AccountApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  String baseAPI = GetIt.instance<String>();

  AccountApi(this._http, this._authenticationClient);

  Future<HttpResponse<bool>> updateUserQR(String uri) async {
    Logs.p.i(uri);
    final String? token = await _authenticationClient.accesToken;
    return _http.request<bool>(
      uri,
      method: "PUT",
      headers: {'token': token},
    );
  }

  Future<HttpResponse<User>> getUserInfo() async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<User>(
      "${baseAPI}user-info",
      method: "GET",
      headers: {'token': token},
      parser: (data) => User.fromJson(data),
    );
  }
}
