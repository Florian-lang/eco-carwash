import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


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
    final String url = "https://www.google.com/maps/search/?api=1&query=47.6,-122.3";
    final Uri uri = Uri.parse(url);

    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    }else{
      throw "Impossible de lancer $url";
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(name)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 40)),
            GestureDetector(
              onTap: (){
                _launchGPS();
                },
              child: Container(
                child: Column(
                  children: [
                    Text(address),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 20,),
                        Text('La latitude : $latitude', style: const TextStyle(fontSize: 20)),
                        Text('La longitude : $longitude', style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 20,)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            // Text("Prix :  $prices", style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 60),

          ],
        ),
      )
    );
  }
}