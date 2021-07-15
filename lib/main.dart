
import 'package:firebase_core/firebase_core.dart';

// @dart=2.9
import 'package:flutter/material.dart';

import 'package:handicraft_app/pages/home_page.dart';
import 'package:handicraft_app/pages/login_page.dart';
import 'package:handicraft_app/pages/register_page.dart';
import 'package:handicraft_app/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Handicraft',
        initialRoute: 'home',
        routes: {
          'home': (BuildContext context) => MainExpandableNavBar(),
          'register': (BuildContext context) => RegisterPage(),
          'login': (BuildContext context) => LoginPage(),
        },

        // Tema de la aplicacion, poder cambiar los colores por defecto de la aplicacion
        theme: ThemeData(
          primaryColor: Colors.indigo,
          floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.indigo),
        ),

      ),
  );
}
