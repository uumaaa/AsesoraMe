import 'package:asispnia/data/authentication_client.dart';
import 'package:asispnia/helpers/http.dart';
import 'package:get_it/get_it.dart';
import '../model/http_response.dart';
import '../model/player.dart';

class PlayerApi {
  final Http _http;
  final AuthenticationClient _authenticationClient;
  String baseAPI = GetIt.instance<String>();

  PlayerApi(this._http, this._authenticationClient);

  Future<HttpResponse<Player>> getPlayerInfo() async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<Player>(
      "${baseAPI}player-info",
      method: "GET",
      headers: {'token': token},
      parser: (data) => Player.fromJson(data),
    );
  }

  Future<HttpResponse<bool>> updateScore(String id, double score) async {
    final String? token = await _authenticationClient.accesToken;
    return _http.request<bool>(
      "${baseAPI}player/$id/score",
      method: "PUT",
      data: {"score": score},
      headers: {'token': token},
    );
  }
}
