import 'package:eco_carwash/model/wash_station.dart';
import 'package:eco_carwash/model/user.dart';

final class Price {
  final int? id;
  final double value;
  final double rate;
  final WashStation washStation;
  final User modelUser;

  Price({
    required this.id,
    required this.value,
    required this.rate,
    required this.washStation,
    required this.modelUser
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'],
      value: json['value'],
      rate: json['rate'],
      washStation: json['washStation'],
      modelUser: json['modelUser']
    );
  }
}