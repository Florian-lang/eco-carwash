import 'package:eco_carwash/price_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/wash_station.dart';

class WashStationPage extends StatefulWidget{
  final WashStation washStation;

  const WashStationPage(
      {super.key, required this.washStation}
  );

  @override
  State<WashStationPage> createState() => _WashStationPageState();
}

class _WashStationPageState extends State<WashStationPage> {
  bool isloggin = false;

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  void _launchGPS() async {
    late Uri uri;

    if (Platform.isAndroid) {
      uri = Uri(scheme: 'geo', host: '0.0', queryParameters: {'q': '${widget.washStation.latitude},${widget.washStation.longitude}'});
    } else if (Platform.isIOS) {
      uri = Uri.https('maps.apple.com', '/', {'ll': '${widget.washStation.latitude},${widget.washStation.longitude}'});
    } else {
      uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '${widget.washStation.latitude},${widget.washStation.longitude}'});
    }

    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    }else{
      throw "Impossible de lancer $uri";
    }
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot){
        if(snapshot.data == true){isloggin = true;}
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.washStation.name, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.washStation.name, style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _launchGPS,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(widget.washStation.address, style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1.5,
                              wordSpacing: 2
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  ButtonTheme(child: ElevatedButton(
                    onPressed: (){
                      widget.washStation.getPrices();
                    },
                    child: const Text('Voir les tarifs'),
                  ),
                  ),
                  if(isloggin)
                    ButtonTheme(
                      minWidth: 200.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => WashStationPricePage(washStation: widget.washStation)));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 10),
                            Text('Ajouter un nouveau tarif'),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 60),
                ],
              ),
            )
        );
      });
  }
}