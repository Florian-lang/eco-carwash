final class Price {
  final int? id;
  final double value;
  final int rate;
  final String washStation;
  final String modelUser;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'rate': rate,
      'washStation': washStation,
      'modelUser': modelUser
    };
  }
}