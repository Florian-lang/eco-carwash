import 'package:eco_carwash/page/wash_station_page.dart';
import 'package:eco_carwash/service/tools_service.dart';
import 'package:eco_carwash/service/wash_stations_service.dart';
import 'package:flutter/material.dart';

import '../model/wash_station.dart';
import '../repository/wash_station_repository.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  final WashStationRepository _washStationRepository = WashStationRepository();
  final WashStationService _washStationService = WashStationService();

  String sortBy = 'price';
  String searchAddress = '';
  List<WashStation> washStations = [];
  bool isLoading = true;
  final ToolsService toolsService = ToolsService();

  @override
  void initState() {
    super.initState();
    _washStationRepository.getWashStations().then((List<WashStation> stations) {
      setState(() {
        washStations = stations;
        isLoading = false;
      });
    });
  }

  void resetFilters() {
    setState(() {
      sortBy = 'price';
      searchAddress = '';
     initState();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //CircleAvatar(
                    //radius: 40,
                    //backgroundImage: AssetImage('assets/logo.png'), // Replace with your logo
                  //),
                  SizedBox(height: 10),
                  Text(
                    'Eco CarWash',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Mon compte'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Aide'),
              onTap: toolsService.sendEmail,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                // Handle logout action
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(10, 70, 10, 0),
                      items: [
                        const PopupMenuItem<String>(
                          value: 'price',
                          child: Text('Trier par prix'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'address',
                          child: Text('Trier par adresse'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'reset',
                          child: Text('Réinitialiser les filtres'),
                        ),
                      ],
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          if (value == 'reset') {
                            resetFilters();
                          } else {
                            sortBy = value;
                            if (sortBy == 'price') {
                              searchAddress = '';
                              _washStationService.filterWashStations(washStations, sortBy, searchAddress);
                            } else if (sortBy == 'address') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Rechercher par adresse'),
                                  content: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Adresse',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      searchAddress = value;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _washStationService.filterWashStations(washStations, sortBy, searchAddress);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        });
                      }
                    });
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.filter_list),
                      SizedBox(width: 5),
                      Text('Filter'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: washStations.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    WashStation washStation = washStations[index];
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          WashStationPage(washStation: washStation),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                        Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(washStations[index].name),
                              subtitle: Text(
                                washStations[index].address,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary,
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