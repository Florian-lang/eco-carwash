import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Entity/WashStation.dart';
import 'loginPage.dart';
import 'WashStation/washStation_page.dart' as WashPage;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Eco CarWash'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<WashStation>> fetchWashStations() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/wash_stations?page=1'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List washStations = jsonResponse['hydra:member'];

    // List<WashStation> wash_stationList = [
    //   WashStation(id:1, name: "station 1", address: "1 rue gpt", latitude: 50, longitude: 50, price: 10.1),
    //   WashStation(id:2, name: "station 2", address: "2 rue gpt", latitude: 50, longitude: 50, price: 10.2),
    //   WashStation(id:3, name: "station 3", address: "3 rue gpt", latitude: 50, longitude: 50, price: 10.3),
    //   WashStation(id:4, name: "station 4", address: "4 rue gpt", latitude: 50, longitude: 50, price: 10.4)
    // ];
    // return wash_stationList;

      return washStations.map((item) => WashStation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load wash stations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Mon compte'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<WashStation>>(
        future: fetchWashStations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => WashPage.WashStationPage(name: snapshot.data![index].name, address: snapshot.data![index].address, latitude: snapshot.data![index].latitude, longitude: snapshot.data![index].longitude)));
                },
                child: ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].address),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
