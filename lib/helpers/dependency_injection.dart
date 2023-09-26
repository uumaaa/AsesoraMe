import 'package:asispnia/api/account_api.dart';
import 'package:asispnia/api/authentification_api.dart';
import 'package:asispnia/api/counseling_api.dart';
import 'package:asispnia/api/player_api.dart';
import 'package:asispnia/data/authentication_client.dart';
import 'package:asispnia/helpers/http.dart';
import 'package:asispnia/model/counseling.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

abstract class DependencyInjection {
  static void initialize() {
    const String baseAPI = "http://192.168.22.207:8000/";
    GetIt.instance.registerSingleton<String>(baseAPI);
    final Dio dio = Dio();
    GetIt.instance.allowReassignment = true;
    bool keepSession = false;
    Http http = Http(dio: dio);
    final AuthentificationApi api = AuthentificationApi(http);
    const FlutterSecureStorage secureStore = FlutterSecureStorage();
    final AuthenticationClient authenticationClient =
        AuthenticationClient(secureStore, api);
    final AccountApi accountApi = AccountApi(http, authenticationClient);
    final PlayerApi playerApi = PlayerApi(http, authenticationClient);
    final CounselingApi counselingApi =
        CounselingApi(http, authenticationClient);
    GetIt.instance.registerSingleton<AuthentificationApi>(api);
    GetIt.instance
        .registerSingleton<AuthenticationClient>(authenticationClient);
    GetIt.instance.registerSingleton<AccountApi>(accountApi);
    GetIt.instance.registerSingleton<PlayerApi>(playerApi);
    GetIt.instance.registerFactory<bool>(
      () => keepSession,
    );
    GetIt.instance.registerSingleton<CounselingApi>(counselingApi);
  }
}
