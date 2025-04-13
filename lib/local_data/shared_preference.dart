import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorage {
  static late SharedPreferences _preferences;

  static const String userNameKey = 'user_name';

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> cacheData(String key, dynamic value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    } else if (value is bool) {
      await _preferences.setBool(key, value);
    } else if (value is int) {
      await _preferences.setInt(key, value);
    } else if (value is double) {
      await _preferences.setDouble(key, value);
    } else if (value is List<String>) {
      await _preferences.setStringList(key, value);
    }
  }

  static dynamic getData(String key) {
    if (key == 'user_id') {
      return _preferences.getInt(key);
    }
    return _preferences.get(key);
  }

  static Future<void> cacheCart(Map<String, dynamic> cartData) async {
    await cacheData('cached_cart', jsonEncode(cartData));
  }

  static Map<String, dynamic>? getCachedCart() {
    final cartJson = getData('cached_cart');
    if (cartJson != null) {
      return jsonDecode(cartJson);
    }
    return null;
  }

  static Future<void> removeData(String key) async {
    await _preferences.remove(key);
  }

  static Future<void> clearData() async {
    await _preferences.clear();
  }
}