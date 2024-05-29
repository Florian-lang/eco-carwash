import 'package:eco_carwash/page/wash_station_map_page.dart';
import 'package:eco_carwash/config.dart';
import 'package:eco_carwash/page/setting_page.dart';
import 'package:eco_carwash/service/user_service.dart';
import 'package:eco_carwash/service/tools_service.dart';
import 'package:eco_carwash/service/wash_stations_service.dart';
import 'package:eco_carwash/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/paginator.dart';
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
  final UserService _userService = UserService();
  final _pagingController = PagingController<int, WashStation>(
    firstPageKey: 1,
  );

  String sortBy = 'price';
  String searchAddress = '';
  List<WashStation> washStations = [];
  bool isLoading = true;
  final ToolsService toolsService = ToolsService();


  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _fetchPage(_pagingController.firstPageKey);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    setState(() {
      isLoading = true;
    });

    try {
      final newItems = await _washStationRepository.getWashStations(pageKey);

      final isLastPage =
          newItems.items.length < Paginator.DEFAULT_ITEM_PER_PAGE;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.items);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.items, nextPageKey);
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void resetFilters() {
    setState(() {
      sortBy = 'price';
      searchAddress = '';
      initState();
    });
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(Config.API_URL);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(name: widget.title),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //CircleAvatar(
                  //radius: 40,
                  //backgroundImage: AssetImage('assets/logo.png'), // Replace with your logo
                  //),
                  const SizedBox(height: 10),
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.api),
              title: const Text('Voir l\'API'),
              onTap: () {
                _launchUrl();
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
                 toolsService.showLogoutConfirmationDialog(context);// Refresh the UI
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
                : PagedListView<int, WashStation>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<WashStation>(
                      itemBuilder: (context, item, index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => 
                                WashStationMapPage(washStation: item)
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
                                    title: Text(item.name),
                                    subtitle: Text(
                                      item.address,
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
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}
