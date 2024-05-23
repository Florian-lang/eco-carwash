import 'dart:convert';
import 'package:eco_carwash/model/response.dart';
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
}