import 'package:eco_carwash/model/wash_station.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/price.dart';
import '../model/user.dart';
import '../repository/price_repository.dart';
import '../repository/user_repository.dart';

final class PriceService {
  final _userRepository = UserRepository();
  final _priceRepository = PriceRepository();

  void savePrice(String priceValue, WashStation washStation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user');

    User user = await _userRepository.getUserByUsername(userEmail!);

    Price price = Price(
      id: null,
      value: double.parse(priceValue),
      rate: 0,
      washStation: washStation.iri,
      modelUser: user.iri,
    );

    await _priceRepository.create(price);
  }
}