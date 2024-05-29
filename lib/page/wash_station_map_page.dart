import 'package:eco_carwash/model/price.dart';
import 'package:eco_carwash/page/price_page.dart';
import 'package:eco_carwash/repository/price_repository.dart';
import 'package:eco_carwash/widget/custom_app_bar.dart';
import 'package:eco_carwash/widget/info_container.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/wash_station.dart';
import '../service/user_service.dart';
import '../service/wash_stations_service.dart';

class WashStationMapPage extends StatefulWidget {
  final WashStation washStation;

  const WashStationMapPage({super.key, required this.washStation});

  @override
  State<WashStationMapPage> createState() => _WashStationMapPageState();
}

class _WashStationMapPageState extends State<WashStationMapPage> {
  final _priceRepository = PriceRepository();
  final _userService = UserService();
  final _washStationService = WashStationService();

  bool isloggin = false;
  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _userService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            isloggin = true;
          }
          return Scaffold(
            appBar: CustomAppBar(name: widget.washStation.name),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Stack(children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.washStation.latitude,
                      widget.washStation.longitude),
                  zoom: 14.4746,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.washStation.id.toString()),
                    position: LatLng(widget.washStation.latitude,
                        widget.washStation.longitude),
                    infoWindow: InfoWindow(
                      title: widget.washStation.name,
                      snippet: widget.washStation.address,
                    ),
                  ),
                },
              ),
              Positioned(
                bottom: 50,
                left: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: const Icon(Icons.info),
                ),
                ),
              if (isShow)
                Positioned(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.05,
                    maxChildSize: 0.8,
                    builder: (BuildContext context,ScrollController myScrollController) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0, 
                          spreadRadius: 1.0,
                        ),
                      ],),
                    child: ListView.builder(
                      controller: myScrollController,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
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
            );                    },
                  ),
                ),
              )),
            ]),
          );
        });
  }
}
