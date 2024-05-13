import 'package:eco_carwash/pricePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loginPage.dart';

class DynamicDrawer extends StatefulWidget {
  const DynamicDrawer({Key? key}) : super(key: key);

  @override
  _DynamicDrawerState createState() => _DynamicDrawerState();
}

class _DynamicDrawerState extends State<DynamicDrawer> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
          if (_isLoggedIn)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Saisir un tarif'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WashStationPricePage()));
              },
            ),
        ],
      ),
    );
  }
}