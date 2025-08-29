import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static PreferencesService? _instance;
  static SharedPreferences? _preferences;

  PreferencesService._internal();

  static Future<PreferencesService> get instance async {
    _instance ??= PreferencesService._internal();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance!;
  }

  final _authorizationPassed = "authorizationPassed";
  final _accessToken = "accessToken";
  final _refreshToken = "refreshToken";
  final _name = "name";
  final _pin = "pin";
  final _isBiometricsEnabled = "_isBiometricsEnabled";
  final _appLanguage = "az";
  final _pinPassed = "pinPassed";
  final _biometric = "biometric";
  final _langTitle = "langTitle";
  final _isNotificationEnabled = "isNotificationEnabled";
  final _laterOption = "later";
  final _userId = "userId";

  setAuthorizationPassed(bool value) async => await _preferences?.setBool(_authorizationPassed, value);
  setPin(String value) async => await _preferences?.setString(_pin, value);
  setAccessToken(String value) async => await _preferences?.setString(_accessToken, value);
  toggleBiometrics(bool value) async => await _preferences?.setBool(_isBiometricsEnabled, value);
  askPin(bool value) async => await _preferences?.setBool(_pinPassed, value);
  setBiometric(bool value) async => await _preferences?.setBool(_biometric, value);
  setOptionLater(bool value) async => await _preferences?.setBool(_laterOption, value);
  setRefreshToken(String value) async => await _preferences?.setString(_refreshToken, value);
  setName(String value) async => await _preferences?.setString(_name, value);
  setLanguage(String value) async => await _preferences?.setString(_appLanguage, value);
  setLanguageTitle(String value) async => await _preferences?.setString(_langTitle, value);
  setUserId(int value) async => await _preferences?.setInt(_userId, value);
  setNotificationEnabled(bool value) async => await _preferences?.setBool(_isNotificationEnabled, value);

  String? get languageTitle => _preferences?.getString(_langTitle);
  String? get appLanguage => _preferences?.getString(_appLanguage);
  bool get wasAuthorizationPassed => _preferences?.getBool(_authorizationPassed) ?? false;
  String? get accessToken => _preferences?.getString(_accessToken);
  bool get isBiometric => _preferences?.getBool(_biometric) ?? false;
  bool get isOptionLaterSaved => _preferences?.getBool(_laterOption) ?? false;
  bool get hasPin => _preferences?.getString(_pin) != null;
  bool get isNotificationEnabled => _preferences?.getBool(_isNotificationEnabled) ?? false;
  bool get isBiometricsEnabled => _preferences?.getBool(_isBiometricsEnabled) ?? false;
  bool get wasPinPassed => _preferences?.getBool(_pinPassed) ?? false;
  String? get refreshToken => _preferences?.getString(_refreshToken);
  String? get name => _preferences?.getString(_name);
  String? get pin => _preferences?.getString(_pin);
  int? get userId => _preferences?.getInt(_userId);

  Future<bool?> clear() async => await _preferences?.clear();
  Future<bool?> clearPin() async => await _preferences?.remove(_pin);
}
