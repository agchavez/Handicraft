import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService with ChangeNotifier {
  // Create storage
  final storage = new FlutterSecureStorage();

  // Read value
  // String value = await storage.read(key: key);

  Future<bool> setValue(String value, String key) async {
    try {
      await storage.write(key: key, value: value);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getValue(String key) async {
    try {
      final value = await storage.read(key: key);
      return value;
    } catch (e) {
      return "";
    }
  }

  Future<dynamic> deleteValue(String key) async {
    try {
      await storage.delete(key: key);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> deleteAll() async {
    try {
      await storage.deleteAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>> getall() async {
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }
}
// // Read all values
// 

// // Delete value
// await storage.delete(key: key);

// // Delete all
//

// // Write value
// await storage.write(key: key, value: value);
