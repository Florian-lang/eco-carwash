import 'package:eco_carwash/page/wash_station_page.dart';
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

// TODO gerer un boutton reset filter pour retirer les filtres  et aussi gestion des addres ergonomiques
class _HomePageState extends State<HomePage> {
  final WashStationRepository _washStationRepository = WashStationRepository();
  final WashStationService _washStationService = WashStationService();

  String sortBy = 'price';
  String searchAddress = '';
  List<WashStation> washStations = [];
  bool isLoading = true;

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
                  color: Theme.of(context).colorScheme.surfaceVariant),
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
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
                  child: DropdownButton<String>(
                    value: sortBy,
                    items: const [
                      DropdownMenuItem(
                          value: 'price', child: Text('Trier par prix')),
                      DropdownMenuItem(
                          value: 'address', child: Text('Trier par adresse')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sortBy = value!;
                        isLoading = true;
                        if (sortBy == 'price') {
                          searchAddress = '';
                        }
                        _washStationService.filterWashStations(washStations, sortBy, searchAddress)
                            .then((stations) => setState(() {
                              washStations = stations;
                          }),
                        );

                        isLoading = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                if (sortBy == 'address')
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Rechercher par adresse',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          isLoading = true;
                          searchAddress = value;
                          _washStationService.filterWashStations(washStations, sortBy, searchAddress)
                              .then((stations) => setState(() {
                                washStations = stations;
                            }),
                          );
                          isLoading = false;
                        });
                      },
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
