import 'dart:math';

import 'package:flutter/material.dart';

class WashStationPage extends StatelessWidget{
  const WashStationPage({super.key, required this.name, required this.address, required this.latitude, required this.longitude});
  final String name;
  final String address;
  final int latitude;
  final int longitude;
  // final double price;

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
            Text(address),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20,),
                Text('La latitude : $latitude', style: const TextStyle(fontSize: 20)),
                Text('La longitude : $longitude', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20,)
              ],
            ),
            const SizedBox(height: 60),
            // Text("Prix :  $price", style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 60),

          ],
        ),
      )
    );
  }
}