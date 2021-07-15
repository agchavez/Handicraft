import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Create storage
  final storage = new FlutterSecureStorage();

  // Read value
  // String value = await storage.read(key: key);

  Future<dynamic> setValue(String value, String key) async {
    try {
      await storage.write(key: key, value: value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getValue(String key) async {
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
      return "";
    }
  }
}
// // Read all values
// Map<String, String> allValues = await storage.readAll();

// // Delete value
// await storage.delete(key: key);

// // Delete all
// await storage.deleteAll();

// // Write value
// await storage.write(key: key, value: value);
