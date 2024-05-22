import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Entity/WashStation.dart';
import 'loginPage.dart';
import 'WashStation/washStationPage.dart';

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
        colorSchemeSeed:Color.fromARGB(255, 18, 234, 245),
        // colorSchemeSeed:Color.fromARGB(255, 77, 125, 180),
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
  String sortBy ='price';
  String searchAddress = '';
  List<WashStation> washStations = [];
  List<WashStation> filteredStations = [];
  bool isLoading = true;
  @override
  void initState(){
    super.initState();
    fetchWashStations();
  }

  Future<void> fetchWashStations() async {
    final response = await http.get(Uri.parse('http://localhost:8081/api/wash_stations?page=1'));


    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List washStations = jsonResponse['hydra:member'];
      List<WashStation> stations= washStations.map((item) => WashStation.fromJson(item)).toList();
      setState(() {
        washStations = stations;
        filteredStations = stations;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load wash stations');
    }
  }
  void filterStations(){
    List<WashStation> tempStations = washStations;
    if(searchAddress.isNotEmpty){
      tempStations= tempStations.where((station)=>
          station.address.toLowerCase().contains(searchAddress.toLowerCase())).toList();
    }
    if(sortBy=='price'){
      //tempStations.sort((a, b)=> a.price.compareTo(b.price));
    }else if( sortBy=='address'){
      tempStations.sort((a,b)=> a.address.compareTo(b.address));

    }
    setState(() {
      filteredStations=tempStations;
    });
  }
  

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Mon compte'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Rechercher par adresse',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchAddress = value;
                        filterStations();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: sortBy,
                  items: const [
                    DropdownMenuItem(value: 'price', child: Text('Trier par prix')),
                    DropdownMenuItem(value: 'address', child: Text('Trier par adresse')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      sortBy = value!;
                      filterStations();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredStations.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    WashStation washStation = filteredStations[index];
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WashStationPage(washStation: washStation),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(filteredStations[index].name),
                              subtitle: Text(
                                filteredStations[index].address,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: Icon(Icons.euro)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}