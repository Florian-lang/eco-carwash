import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entity/WashStation.dart';

class WashStationPage extends StatefulWidget{
  const WashStationPage({Key? key, required this.washStation}) : super(key: key);

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
              title: Text(widget.washStation.name),
              backgroundColor: Colors.lightBlueAccent,
            ),
            backgroundColor: Colors.deepPurpleAccent[50],
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.washStation.name, style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _launchGPS,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          Text(widget.washStation.address, style: const TextStyle(
                              fontSize: 24,
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
                    const Icon(Icons.euro),
                  const SizedBox(height: 60),
                ],
              ),
            )
        );
      });
  }
}