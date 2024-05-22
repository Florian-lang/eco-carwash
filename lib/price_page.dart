import 'dart:convert';

import 'package:eco_carwash/model/wash_station.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'model/price.dart';
import 'model/user.dart';

class WashStationPricePage extends StatefulWidget {
  final WashStation washStation;

  const WashStationPricePage({Key? key, required this.washStation}) : super(key: key);

  @override
  _WashStationPricePage createState() => _WashStationPricePage();
}

class _WashStationPricePage extends State<WashStationPricePage> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  void savePrice() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('user');

      if(userEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vous devez être connecté pour enregistrer un tarif')),
        );
        return;
      }

      User user = await User.getUserByUsername(userEmail);
      Price price = Price(
        id: null,
        value: double.parse(_priceController.text),
        rate: 0,
        washStation: widget.washStation.iri,
        modelUser: user.iri,
      );

      final response = await http.post(
        Uri.parse('${Config.API_URL}prices'),
        headers: <String, String>{
          'Content-Type': 'application/ld+json; charset=UTF-8',
        },
        body: jsonEncode(price),
      );

      if(response.statusCode != 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'enregistrement du tarif')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarif enregistré')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarif', style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Saisir le tarif de la station de lavage'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un tarif';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                savePrice();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
              child: Text('Enregistrer', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}