import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUsers {
  static final PreferencesUsers _instancia = new PreferencesUsers._internal();
  late SharedPreferences _prefs;

  factory PreferencesUsers() {
    return _instancia;
  }

  PreferencesUsers._internal();

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  // GET y SET de la última página
  String get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }
}
