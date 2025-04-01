import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

//all shared pref related keys
const String BN = "bn";
const String EN = "en";
const String BD = "BD";
const String US = "US";
const String LANGUAGE = "language";
const String NAME = "NAME";
const String PHOTO = "PHOTO";
const String QR = "QR";
const String PERSONA_VALUE = "PERSONA_VALUE";

const String AUTHORIZATION_TOKEN = "AUTHORIZATION_TOKEN";
const String REFRESH_TOKEN = "REFRESH_TOKEN";
const String DEVICE_AUTHORIZATION_TOKEN = "DEVICE_AUTHORIZATION_TOKEN";
const String WALLET_NUMBER = "WALLET_NUMBER_";
const String DEVICE_UUID = "DEVICE_UUID";

//helper class
class SharedPreferenceHelper {
  static final SharedPreferenceHelper _instance =
      SharedPreferenceHelper._internal();

  late SharedPreferences _prefs;

  factory SharedPreferenceHelper() {
    return _instance;
  }

  SharedPreferences getSharedPrefHelperInstance() {
    return _prefs;
  }

  SharedPreferenceHelper._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> deleteAllData() async {
    _prefs.clear();
  }

  Future<void> setStringAsEncrypt(String key, String value) async {
    EncryptedSharedPreferences encryptedSharedPreferences =
        EncryptedSharedPreferences(prefs: _prefs);
    encryptedSharedPreferences.setString(key, value);
  }

  Future<String> getEncryptedString(String key) async {
    EncryptedSharedPreferences encryptedSharedPreferences =
        EncryptedSharedPreferences(prefs: _prefs);
    try {
      return await encryptedSharedPreferences.getString(key);
    } catch (error) {
      return "";
    }
  }
}
