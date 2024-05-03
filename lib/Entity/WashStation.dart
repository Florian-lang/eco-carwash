import 'dart:ffi';

class WashStation {
  final int id;
  final String name;
  final String address;
  final int latitude;
  final int longitude;

  WashStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude
  });

  factory WashStation.fromJson(Map<String, dynamic> json) {
    return WashStation(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}