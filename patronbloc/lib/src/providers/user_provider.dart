import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:patronbloc/src/Preferences/preferences_users.dart';

class UserProvider {
  //Petición para FireBase

  String _fireBaseToken = '';
  String _url = 'identitytoolkit.googleapis.com';

  String _pathSignUp = 'v1/accounts:signUp'; //v1/accounts:signUp?key=[API_KEY]

  String _pathSignIn =
      'v1/accounts:signInWithPassword'; //v1/accounts:signInWithPassword?key=[API_KEY]

  final _prefs =
      new PreferencesUsers(); //Singleton, siempre será la misma instancia.

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      //Body codificado.
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final Uri _uriS = Uri.https(
      _url,
      _pathSignUp,
      {"key": _fireBaseToken},
    );

    print(_uriS.toString());

    http.Response response =
        await http.post(_uriS, body: json.encode(authData));

    Map<String, dynamic> decodedData = json.decode(response.body);

    print('newUser - $decodedData');

    if (decodedData.containsKey('idToken')) {
      _prefs.token = decodedData[
          'idToken']; //Se almacena el valor en las preferencias del dispositivo.
      return {'ok': true, 'token': decodedData['idToken']};
    } else {
      //Error
      return {'ok': false, 'token': decodedData['error']['message']};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      //Body codificado.
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final Uri _uriS = Uri.https(
      _url,
      _pathSignIn,
      {"key": _fireBaseToken},
    );

    print(_uriS.toString());

    http.Response response =
        await http.post(_uriS, body: json.encode(authData));

    print('Login - response.statusCode : ${response.statusCode}');

    Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData.containsKey('idToken')) {
      _prefs.token = decodedData[
          'idToken']; //Se almacena el valor en las preferencias del dispositivo.
      return {'ok': true, 'token': decodedData['idToken']};
    } else {
      //Error
      return {'ok': false, 'token': decodedData['error']['message']};
    }
  }
}
