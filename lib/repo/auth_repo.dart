import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vibank/models/user.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

class AuthRepo {
  //static const url = 'http://localhost:3000/auth';

  static const url = "https://web-production-9dfe.up.railway.app/auth";

  final _controller = StreamController<AuthenticationStatus>();

  static const storege = FlutterSecureStorage();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<User> signin(String phone, String country) async {
    try {
      final response = await http.post(
        Uri.parse("$url/login"),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode(<String, String>{'phone': phone, 'country': country}),
      );

      if (response.statusCode != 200) {
        Map<String, dynamic> error = jsonDecode(response.body);

        throw error['message'];
      }
      final json = jsonDecode(response.body);

      final user = User.fromJson(json);

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> login({required String id, required String code}) async {
    try {
      final response = await http.post(
        Uri.parse("$url/verify"),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode(<String, String>{'id': id, 'code': code}),
      );

      if (response.statusCode != 200) {
        Map<String, dynamic> error = jsonDecode(response.body);

        throw error['message'];
      }
      final Map<String, dynamic> json = jsonDecode(response.body);

      await storege.write(key: 'access_token', value: json['access_token']);
      await storege.write(key: 'refresh_token', value: json['refresh_token']);

      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      final accessToken = await AuthRepo.storege.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$url/logout'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      if (response.statusCode != HttpStatus.noContent) {
        throw "Authorization failed";
      }

      await storege.deleteAll();

      _controller.add(AuthenticationStatus.unauthenticated);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> restore() async {
    try {
      final token = await storege.read(key: 'refresh_token');

      if (token == null || token.isEmpty) {
        throw 'Auth token not found';
      }

      final response = await http.get(
        Uri.parse("$url/refresh"),
        headers: {'x-refresh-token': token},
      );

      if (response.statusCode != 200) {
        Map<String, dynamic> error = jsonDecode(response.body);

        throw error['message'];
      }

      final Map<String, dynamic> json = jsonDecode(response.body);

      await storege.write(key: 'access_token', value: json['access_token']);
      await storege.write(key: 'refresh_token', value: json['refresh_token']);

      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      throw e.toString();
    }
  }

  void dispose() => _controller.close();
}
