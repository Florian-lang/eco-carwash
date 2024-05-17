import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8081/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if(response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('L\'identifiant ou le mot de passe est incorrect'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String token = jsonResponse['token'];
      String username = jsonResponse['user'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      throw Exception('Failed to login');
    }
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

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('user');
    return username ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.data == true) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Déconnexion'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(future: getUsername(), builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Text('Vous êtes connecté en tant que ${snapshot.data}');
                  }),
                  ElevatedButton(
                    onPressed: () {
                      logout();
                      setState(() {});  // Refresh the UI
                    },
                    child: const Text('Se déconnecter'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Connexion'),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Mot de passe'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}