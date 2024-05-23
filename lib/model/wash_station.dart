import 'dart:async';
import 'dart:convert';
import 'package:eco_carwash/model/price.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

final class WashStation {
  // TODO : remettre les champs en commentaire une fois ls champs de base de données changés

  static const String _IRI = '/api/wash_stations';

  final int? id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  // final List<dynamic> prices;

  WashStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    // required this.prices
  });

  factory WashStation.fromJson(Map<String, dynamic> json) {
    return WashStation(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      // prices: json['prices']
    );
  }

  Future<List<Price>> getPrices() async {
    final response = await http.get(
        Uri.parse('${Config.API_URL}wash_stations/$id'));

    print(response.body);
    if (response.statusCode == 200) {
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

  String get iri => '$_IRI/$id';
}