import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class CountrieCityProvider {
  List<dynamic> opciones = [];

  CountrieCityProvider() {
    cargarData();
  }

  Future<List<dynamic>> cargarData() async {
    final resp = await rootBundle.loadString('data/paises.json');
    Map dataMap = json.decode(resp);
    print(dataMap);
    return opciones;
  }
}

final menuProvider = new CountrieCityProvider();
