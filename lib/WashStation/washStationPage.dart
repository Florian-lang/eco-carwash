import 'package:eco_carwash/pricePage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entity/WashStation.dart';

class WashStationPage extends StatefulWidget{
  const WashStationPage({super.key, required this.washStation});

  final WashStation washStation;
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
              // backgroundColor: Colors.lightBlueAccent,
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
                  // Text("Prix :  ${washStation.prices}", style: const TextStyle(fontSize: 30)),
                  if(isloggin)
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WashStationPricePage()));
                      },
                      child: const Icon(Icons.euro)),

                  const SizedBox(height: 60),
                ],
              ),
            )
        );
      });
  }
}