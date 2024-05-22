import 'dart:convert';

import 'package:http/http.dart' as http;

final class User {
  final int id;
  final String email;
  final String password;
  final List<String> roles;
  final List<String> prices;
  final int appreciation;

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.roles,
    required this.prices,
    required this.appreciation
  });

factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        roles: List<String>.from(json['roles']),
        prices: List<String>.from(json['prices']),
        appreciation: json['appreciation']
    );
  }

  static Future<User> getUserByUsername(String username) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/users?page=1&email=$username'));

    if (response.statusCode == 200) {
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

  static Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/users/$id'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load user');
    }
  }
}