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

  String get iri => '$_IRI/$id';
}