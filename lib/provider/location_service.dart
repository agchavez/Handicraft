import 'package:flutter/cupertino.dart';
import 'package:handicraft_app/models/location_model.dart';

class LocationService with ChangeNotifier {
  Future<List<LocationModel>> getContries() async {
    return [LocationModel(1, "Honduras"), LocationModel(2, "Panama")];
  }

  Future<List<LocationModel>> getProvinces(int idContrie) async {
    return [
      LocationModel(1, "La Paz"),
      LocationModel(2, "Marcala"),
      LocationModel(3, "Yarumela"),
      LocationModel(4, "Guajiquiro"),
      LocationModel(5, "mercedes de Oriente"),
      LocationModel(6, "Tutule")
    ];
  }

  Future<List<LocationModel>> getCity(int idContrie, int idProvince) async {
    return [
      LocationModel(1, "La Paz"),
      LocationModel(2, "Comayagua"),
      LocationModel(3, "Fancisco Morazan"),
      LocationModel(4, "Temp"),
      LocationModel(5, "mercedes de Oriente"),
      LocationModel(6, "Tutule")
    ];
  }
}
