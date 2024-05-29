import 'dart:convert';
import 'package:eco_carwash/model/response.dart';
import 'package:eco_carwash/model/wash_station.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/price.dart';

final class PriceRepository {
  Future<void> create(Price price) async {
    final response = await http.post(
      Uri.parse('${Config.API_URL}prices'),
      headers: <String, String>{
        'Content-Type': 'application/ld+json; charset=UTF-8',
      },
      body: jsonEncode(price),
    );

    if (response.statusCode != Response.HTTP_CREATED) {
      throw Exception('Failed to create price');
    }
  }

  Future<List<Price>> getPrices(WashStation washStation) async {
    final response = await http.get(
        Uri.parse('${Config.API_URL}prices?page=1&washStation=${washStation.id}'));

    if (response.statusCode == Response.HTTP_OK) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List data = jsonResponse['hydra:member'];

      List<Price> prices = data.map((item) => Price.fromJson(item)).toList();

      return prices;
    } else {
      throw Exception('Failed to load prices');
    }
  }
}