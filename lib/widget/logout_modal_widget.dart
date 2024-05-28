import 'package:flutter/material.dart';

import '../service/user_service.dart';

class LogoutModalWidget extends StatelessWidget {
  const LogoutModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();

    return AlertDialog(
      title: const Text('Déconnexion'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Voulez-vous vraiment vous déconnecter ?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Non'),
          onPressed: () {
            Navigator.of(context).pop(); // Ferme la boîte de dialogue
          },
        ),
        TextButton(
          child: const Text('Oui'),
          onPressed: () {
            Navigator.of(context).pop(); // Ferme la boîte de dialogue
            userService.logout(); // Appelle la méthode de déconnexion
          },
        ),
      ],
    );
  }
}
