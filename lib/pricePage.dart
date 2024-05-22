import 'package:flutter/material.dart';

class WashStationPricePage extends StatefulWidget {
  const WashStationPricePage({Key? key}) : super(key: key);

  @override
  _WashStationPricePage createState() => _WashStationPricePage();
}

class _WashStationPricePage extends State<WashStationPricePage> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

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
                if (_formKey.currentState!.validate()) {
                  // Ici, vous pouvez gérer la logique pour enregistrer le tarif
                  print('Tarif: ${_priceController.text}');
                }
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