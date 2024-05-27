import 'package:eco_carwash/model/price.dart';
import 'package:eco_carwash/page/price_page.dart';
import 'package:eco_carwash/repository/price_repository.dart';
import 'package:flutter/material.dart';

import '../model/wash_station.dart';
import '../service/user_service.dart';
import '../service/wash_stations_service.dart';

import 'package:eco_carwash/widget/info_container.dart';
import 'package:eco_carwash/widget/custom_app_bar.dart';

class WashStationPage extends StatefulWidget{
  final WashStation washStation;

  const WashStationPage(
      {super.key, required this.washStation}
  );

  @override
  State<WashStationPage> createState() => _WashStationPageState();
}

class _WashStationPageState extends State<WashStationPage> {
  final _priceRepository = PriceRepository();
  final _userService = UserService();
  final _washStationService = WashStationService();

  bool isloggin = false;

  @override
  Widget build(BuildContext context){
    return FutureBuilder<bool>(
      future: _userService.isLoggedIn(),
      builder: (context, snapshot){
        if(snapshot.data == true){isloggin = true;}
        return Scaffold(
            appBar: CustomAppBar(name: widget.washStation.name),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.washStation.name, style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      _washStationService.launchGPS(widget.washStation);
                    },
                    child: MyInfoContainer(title: widget.washStation.address, subtitle: "lattitude: ${widget.washStation.latitude} longitude: ${widget.washStation.longitude}", icon: Icons.launch_outlined),
                  ),
                  const SizedBox(height: 60),
                  FutureBuilder(
                    future: _priceRepository.getPrices(widget.washStation), 
                    builder: (context, snapshot){
                      if(snapshot.data is List<Price>){
                        return Column(
                          children: (snapshot.data?.map<Widget>((price) => MyInfoContainer(title: price.value.toString(), subtitle: "score : ${price.rate}", icon: Icons.money)).toList() ?? []),
                        );
                      }else{
                        return const CircularProgressIndicator();
                      }
                    }
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