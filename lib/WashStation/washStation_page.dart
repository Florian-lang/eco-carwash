import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class WashStationPage extends StatelessWidget{
  const WashStationPage({super.key, required this.name, required this.address, required this.latitude, required this.longitude});
  final String name;
  final String address;
  final int latitude;
  final int longitude;
  // final List<dynamic> prices;

  void _launchGPS() async {
    // const String url = "sms:";
    // const String url = "https://flutter.dev/";
    // final Uri uriTest = Uri.parse(url);

    late Uri uri;
    
    if (Platform.isAndroid) {
      uri = Uri(scheme: 'sms');
      // uri = Uri(scheme: 'geo', host: '0.0', queryParameters: {'q': '$latitude,$longitude'});
      uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '$latitude,$longitude'});
    } else if (Platform.isIOS) {
      uri = Uri.https('maps.apple.com', '/', {'ll': '$latitude,$longitude'});
    } else if (Platform.isFuchsia) {
      uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '$latitude,$longitude'});
    } else {
      uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '$latitude,$longitude'});
    }

    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    }else{
      throw "Impossible de lancer $uri";
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.deepPurpleAccent[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: (){
                _launchGPS();
                },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Couleur de l'ombre
                      spreadRadius: 2, // Rayon de dispersion de l'ombre
                      blurRadius: 2, // Rayon de flou de l'ombre
                      offset: const Offset(0, 3), // Décalage de l'ombre
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(address, style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // color: Colors
                      letterSpacing: 1.5,
                      wordSpacing: 2
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            // Text("Prix :  $prices", style: const TextStyle(fontSize: 30)),
            const Icon(Icons.euro),
            const SizedBox(height: 60),

          ],
        ),
      )
    );
  }
}