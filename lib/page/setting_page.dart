import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.getTheme() == ThemeData.dark(),
            onChanged: (value) {
              themeProvider.setTheme(value ? ThemeData.dark() : ThemeData.from(colorScheme:
                ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 18, 234, 245)),
              ));
            },
          ),
        ],
      ),
    );
  }
}