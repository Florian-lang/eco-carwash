import 'package:eco_carwash/page/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed:Color.fromARGB(255, 18, 234, 245),
        // colorSchemeSeed:Color.fromARGB(255, 77, 125, 180),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Eco CarWash'),
    );
  }
}
