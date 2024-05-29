import 'package:eco_carwash/page/home_page.dart';
import 'package:eco_carwash/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  ThemeData themeData = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 18, 234, 245)),
      useMaterial3: true,
  );

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(themeData),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeProvider.getTheme(),
      home: const HomePage(title: 'Eco CarWash'),
    );
  }
}
