import 'dart:async';
import 'dart:convert';
import 'package:asispnia/api/authentification_api.dart';
import 'package:asispnia/helpers/authentication_response.dart';
import 'package:asispnia/model/http_response.dart';
import 'package:asispnia/model/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class AuthenticationClient {
  final FlutterSecureStorage _secureStore;
  final AuthentificationApi _authentificationApi;
  Completer? _completer;
  AuthenticationClient(this._secureStore, this._authentificationApi);
  void _complete() {
    if (_completer != null) {
      if (!_completer!.isCompleted) {
        _completer!.complete();
      }
    }
  }

  Future<String?> get accesToken async {
    if (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer();
    bool keepSession = GetIt.instance<bool>();
    final String? data = await _secureStore.read(key: "SESSION");
    if (data != null) {
      final Session session = Session.fromJson(jsonDecode(data));
      final DateTime currentDay = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;
      final int diff = currentDay.difference(createdAt).inSeconds;
      if (!keepSession) {
        if (expiresIn - diff <= 0) {
          _complete();
          await sigOutSession();
          return null;
        }
        _complete();
        return session.token;
      }
      if (expiresIn - diff >= 60) {
        _complete();
        return session.token;
      }
      final HttpResponse<AuthenticationResponse> response =
          await _authentificationApi.refreshToken(session.token);
      if (response.data != null) {
        await saveSession(response.data!);
        _complete();
        return response.data!.token;
      }
      _complete();
      return null;
    }
    _complete();
    return null;
  }

  Future<void> saveSession(
      AuthenticationResponse authenticationResponse) async {
    final Session session = Session(
      token: authenticationResponse.token,
      expiresIn: authenticationResponse.expiresIn,
      createdAt: DateTime.now(),
    );
    final String data = jsonEncode(session.toJson());
    await _secureStore.write(key: 'SESSION', value: data);
  }

  Future<void> sigOutSession() async {
    await _secureStore.deleteAll();
  }
}
