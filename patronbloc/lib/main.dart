import 'package:flutter/material.dart';
import 'package:patronbloc/src/Preferences/preferences_users.dart';
import 'package:patronbloc/src/bloc/provider.dart';
import 'package:patronbloc/src/pages/home_page.dart';
import 'package:patronbloc/src/pages/login_page.dart';
import 'package:patronbloc/src/pages/product_page.dart';
import 'package:patronbloc/src/pages/register_page.dart';

//void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs =
      new PreferencesUsers(); //Singleton, siempre será la misma instancia.
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs =
        new PreferencesUsers(); //Singleton, siempre será la misma instancia.
    print('MyApp : ${prefs.token}');

    return ProviderInheritedWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage(),
          'register': (BuildContext context) => RegisterPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          primarySwatch: Colors.deepPurple,
        ),
      ),
    );
  }
}
