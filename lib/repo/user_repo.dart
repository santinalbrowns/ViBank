import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vibank/models/user.dart';

import 'auth_repo.dart';

class UserRepo {
  static const url = 'https://web-production-9dfe.up.railway.app/';

  //static const url = "https://quick-menu-app.herokuapp.com";

  Future<User> getUser() async {
    try {
      final accessToken = await AuthRepo.storege.read(key: 'access_token');

      final response = await http.get(
        Uri.parse("$url/profile"),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
      );

      if (response.statusCode != 200) {
        throw response.body;
      }

      final json = jsonDecode(response.body);

      final user = User.fromJson(json);

      return user;
    } catch (e) {
      throw e.toString();
    }
  }
}
