import 'dart:convert';

import 'package:eco_carwash/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class UserService {
  final UserRepository _userRepository = UserRepository();

  Future<void> login(String email, String password) async {
      final String response = await _userRepository.checkLogin(email, password);

      Map<String, dynamic> jsonResponse = json.decode(response);

      String token = jsonResponse['token'];
      String username = jsonResponse['user'];
      int userId = jsonResponse['userId'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', username);
      await prefs.setInt('userId', userId);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    return userId ?? 0;
  }
}