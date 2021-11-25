import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static Future<String?> isSignedIn() async {
    if (kIsWeb) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (sharedPreferences.containsKey("seedPhase")) {
        return sharedPreferences.getString("seedPhase");
      } else {
        return null;
      }
    }

    FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
    return await flutterSecureStorage.read(key: "seedPhase");
  }

  static Future<void> signIn(String seedPhase) async {
    if (kIsWeb) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("seedPhase", seedPhase);
      return;
    }
    FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
    await flutterSecureStorage.write(key: "seedPhase", value: seedPhase);
  }

  static Future<void> signOut() async {
    if (kIsWeb) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear();
      return;
    }
    FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
    return await flutterSecureStorage.deleteAll();
  }
}
