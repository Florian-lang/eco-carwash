import 'dart:io';
import 'dart:math';

import 'package:eco_carwash/model/wash_station.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

final class WashStationService {
  Future<List<WashStation>> filterWashStations(List<WashStation> washStations, String sortBy, String search)  async {
    if (sortBy == 'address' && search.isNotEmpty) {
      List<Location> locations = await locationFromAddress(search);

      if (locations.isNotEmpty) {
        double searchLat = locations.first.latitude;
        double searchLng = locations.first.longitude;

        washStations.sort((a, b) {
          double distanceA = _calculateDistance(searchLat, searchLng, a.latitude, a.longitude);
          double distanceB = _calculateDistance(searchLat, searchLng, b.latitude, b.longitude);
          return distanceA.compareTo(distanceB);
        });
      }
    }

    return washStations;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // pi / 180
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  void launchGPS(WashStation washStation) async {
    late Uri uri;

    if (Platform.isAndroid) {
      uri = Uri(scheme: 'geo', host: '0.0', queryParameters: {'q': '${washStation.latitude},${washStation.longitude}'});
    } else if (Platform.isIOS) {
      uri = Uri.https('maps.apple.com', '/', {'ll': '${washStation.latitude},${washStation.longitude}'});
    } else {
      uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '${washStation.latitude},${washStation.longitude}'});
    }

    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    }else{
      throw "Impossible de lancer $uri";
    }
  }
}