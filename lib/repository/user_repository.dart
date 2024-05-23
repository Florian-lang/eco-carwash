import 'dart:convert';

import 'package:eco_carwash/model/response.dart';

import '../config.dart';
import '../model/user.dart';

import 'package:http/http.dart' as http;

final class UserRepository {
  Future<User> getUserByUsername(String username) async {
    final response = await http.get(
        Uri.parse('${Config.API_URL}users?page=1&email=$username'));

    if (response.statusCode == Response.HTTP_OK) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      var data = jsonResponse['hydra:member'];
      if (data is List) {
        return User.fromJson(data.first);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('${Config.API_URL}users/$id'));
    if (response.statusCode == Response.HTTP_OK) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<String> checkLogin (String email, String password) async {
    final response = await http.post(
      Uri.parse('${Config.API_URL}login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
    );

    if (response.statusCode != Response.HTTP_OK) {
      throw Exception('Failed to login');
    }

    return response.body;
  }
}
