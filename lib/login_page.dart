import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'model/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late String username;
  late int id;
  bool connexion = false;

  Future<void> login() async {
    setState(() {
      connexion = true;
    });
    final response = await http.post(
      Uri.parse('${Config.API_URL}login'),
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
        SnackBar(
          content: const Text('L\'identifiant ou le mot de passe est incorrect'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        connexion = false;
      });
      return;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String token = jsonResponse['token'];
      String username = jsonResponse['user'];
      int userId = jsonResponse['userId'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', username);
      await prefs.setInt('userId', userId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      throw Exception('Failed to login');
    }
    setState(() {
      connexion = false;
    });
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

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    return userId ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.data == true) { // User is logged in
          return Scaffold(
            appBar: AppBar(
              title: Text('Mon compte', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(future: getUserId(), builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data is int) {
                      // username = snapshot.data!;
                      id = snapshot.data!;
                    }
                    return Column(children: <Widget>[
                      // Text('Connecté en tant que $username'),
                      const Text("coucou bg"),
                      const SizedBox(height: 20),
                      FutureBuilder(
                        future: User.getUserById(id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.data is User) {
                            User user = snapshot.data!;
                            return Text('Appréciation: ${user.appreciation}');
                          }else{
                            return const Text('Erreur lors de la récupération des informations utilisateur');
                          }
                        }
                      ),
                    ],);
                  }),
                  const SizedBox(height: 20),
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
          return Scaffold( // User is not logged in
            appBar: AppBar(
              title: Text('Connexion', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                  if(connexion)
                    const CircularProgressIndicator(),
                  if(!connexion)
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                      child: Text("Se connecter", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
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