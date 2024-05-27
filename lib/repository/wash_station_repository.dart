import 'dart:convert';

import 'package:eco_carwash/model/response.dart';
import 'package:eco_carwash/model/wash_station.dart';

import '../config.dart';
import '../model/paginator.dart';
import '../model/price.dart';

import 'package:http/http.dart' as http;

final class WashStationRepository {
  Future<List<Price>> getPrices(WashStation washStation) async {
    final response = await http.get(
        Uri.parse('${Config.API_URL}wash_stations/${washStation.id}'));

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

  Future<Paginator<WashStation>> getWashStations(int page) async {
    final response = await http.get(Uri.parse('${Config.API_URL}wash_stations?page=$page'));

    if (response.statusCode == Response.HTTP_OK) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List data = jsonResponse['hydra:member'];
      int totalItems = jsonResponse['hydra:totalItems'];

      List<WashStation> washStations = data.map((item) => WashStation.fromJson(item)).toList();

      return Paginator<WashStation>(
        items: washStations,
        totalItems: totalItems,
      );
    } else {
      throw Exception('Failed to load wash stations');
    }
  }
}