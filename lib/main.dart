import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:handicraft_app/pages/detailsProduct.dart';

import 'package:handicraft_app/pages/home_page.dart';
import 'package:handicraft_app/pages/login_page.dart';
import 'package:handicraft_app/pages/register_page.dart';
import 'package:handicraft_app/pages/first-steps.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/provider/google_sign_in.dart';
import 'package:handicraft_app/provider/location_service.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/provider/chat_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Handicraft',
        initialRoute: 'home',
        routes: {
          'home': (BuildContext context) => MainExpandableNavBar(),
          'register': (BuildContext context) => RegisterPage(),
          'login': (BuildContext context) => LoginPage(),
          'details': (BuildContext context) => ProductsDetail(),
          'tips': (BuildContext context) => FlowPager(),
        },

        // Tema de la aplicacion, poder cambiar los colores por defecto de la aplicacion
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          primaryColor: Colors.indigo,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.indigo),
        ),
      ),
    );
  }
}
