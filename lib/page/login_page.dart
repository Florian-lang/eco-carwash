import 'package:eco_carwash/repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../service/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _userRepository = UserRepository();
  final _userService = UserService();

  late String username;
  late int id;

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _userService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.data == true) {
          // User is logged in
          return Scaffold(
            appBar: AppBar(
              title: Text('Mon compte',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                      future: _userService.getUserId(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.data is int) {
                          // username = snapshot.data!;
                          id = snapshot.data!;
                        }
                        return Column(
                          children: <Widget>[
                            // Text('Connecté en tant que $username'),
                            const Text("coucou bg"),
                            const SizedBox(height: 20),
                            FutureBuilder(
                                future: _userRepository.getUserById(id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.data is User) {
                                    User user = snapshot.data!;
                                    return Text(
                                        'Appréciation: ${user.appreciation}');
                                  } else {
                                    return const Text(
                                        'Erreur lors de la récupération des informations utilisateur');
                                  }
                                }),
                          ],
                        );
                      }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _userService.logout();
                      setState(() {}); // Refresh the UI
                    },
                    child: const Text('Se déconnecter'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            // User is not logged in
            appBar: AppBar(
              title: Text(
                'Connexion',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
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
                      decoration:
                          const InputDecoration(labelText: 'Mot de passe'),
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
                  if (isLoaded) const CircularProgressIndicator(),
                  if (!isLoaded)
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              isLoaded = true;
                            });
                            await _userService.login(_emailController.text,
                                _passwordController.text);
                            setState(() {
                              isLoaded = false;
                            });
                          } catch (e) {
                            setState(() {
                              isLoaded = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "L'identifiant ou le mot de passe est incorrect",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError)),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Text(
                        "Se connecter",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
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
