import 'package:flutter/material.dart';
import 'package:handicraft_app/pages/home_page.dart';
import 'package:handicraft_app/pages/login_page.dart';
import 'package:handicraft_app/pages/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Handicraft',
      initialRoute: 'login',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'register': (BuildContext context) => RegisterPage(),
        'login': (BuildContext context) => LoginPage(),
      },

      // Tema de la aplicacion, poder cambiar los colores por defecto de la aplicacion
      theme: ThemeData(
        primaryColor: Colors.indigo,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.white24),
      ),
    );
  }
}
