import 'dart:convert';

import 'package:eco_carwash/model/response.dart';
import 'package:eco_carwash/model/wash_station.dart';

import '../config.dart';
import '../model/price.dart';

import 'package:http/http.dart' as http;

final class WashStationRepository {
  Future<List<Price>> getPrices(WashStation washStation) async {
    final response = await http.get(
        Uri.parse('${Config.API_URL}wash_stations/$washStation.id'));

    if (response.statusCode == Response.HTTP_OK) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      var prices = jsonResponse['prices'];
      if (prices is List) {
        return prices.map((price) => Price.fromJson(price)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load prices');
    }
  }

  Future<List<WashStation>> getWashStations() async {
    final response = await http.get(Uri.parse('${Config.API_URL}wash_stations?page=1'));

    if (response.statusCode == Response.HTTP_OK) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List data = jsonResponse['hydra:member'];

      List<WashStation> washStations = data.map((item) => WashStation.fromJson(item)).toList();

      return washStations;
    } else {
      throw Exception('Failed to load wash stations');
    }
  }
}