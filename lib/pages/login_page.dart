import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/login_user.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/utils/alerts.dart';
import 'package:handicraft_app/utils/util.dart' as utils;
import 'package:handicraft_app/global/enviroment.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final formkey = GlobalKey<FormState>();

bool _showpasword = true, check = false;
LoginAccountModel login_user = new LoginAccountModel();
AuthService auth;
List<Widget> actions = [];
bool _sendingEmail = false;
Map<String, dynamic> _alert = {'title': '', 'content': ''};

final dio = Dio();

class _LoginPageState extends State<LoginPage> {
  Size size = Size(1000, 5000);
  bool _duplicateEmail = false;

  @override
  void initState() {
    auth = Provider.of<AuthService>(context, listen: false);
    auth.stateAuth();
    super.initState();
  }

  void dispose() {
    super.dispose();
    check = false;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: FloatingActionButton(
            child: Image.asset(
              'assets/icons/back-black-icon.png',
              width: 7.0,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.popAndPushNamed(context, 'home');
            },
          ),
          height: 43.0,
          width: 43.0,
        ),
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.12,
            ),
            _logo(),
            SizedBox(
              height: size.height * 0.06,
            ),
            _form(),
            SizedBox(
              height: size.height * 0.06,
            ),
            !check
                ? _createBottom(context)
                : Container(
                    height: 10.0,
                    width: 10.0,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
            SizedBox(
              height: size.height * 0.06,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'register');
                },
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿No tienes una cuenta?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            decoration: TextDecoration.underline)),
                    Text(
                      " Registrarme",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.5),
                    ),
                  ],
                )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                "¿Olvidaste tu contraseña?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[600],
                    decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: size.width * 0.74,
              child: Text(
                "Al Pulsar en Iniciar sesión acepta los términos de uso de Handicraft y política de privacidad.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey[600],
                    fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
        child: Column(
      children: [
        Column(
          children: [
            Image(
                height: size.height * 0.06,
                image: AssetImage('assets/images/logo.png')),
            Text(
              "¡Productos que te encantarán!.",
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            )
          ],
        ),
      ],
    ));
  }

  Widget _form() {
    return SingleChildScrollView(
      child: Form(
          key: formkey,
          child: Column(
            children: [
              _email(),
              SizedBox(
                height: 10,
              ),
              _password(),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  Widget _email() {
    return Container(
        width: size.width * 0.75,
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.7,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Correo electrónico',
          ),
          onSaved: (value) => {login_user.email = value.toString()},
          validator: (value) {
            if (!utils.validatorEmail(value.toString())) {
              return 'Correo no válido';
            } else if (_duplicateEmail) {
              return 'Email en uso.';
            } else {
              return null;
            }
          },
        ));
  }

  Widget _password() {
    bool ban = false;
    return Container(
        width: size.width * 0.75,
        child: TextFormField(
          obscureText: _showpasword,
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.7,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            suffixIcon: GestureDetector(
              child: _showpasword
                  ? Icon(
                      Icons.lock,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.lock_open,
                      color: Colors.black,
                    ),
              onTap: () => {
                setState(() {
                  _showpasword = !_showpasword;
                })
              },
            ),
            hintText: 'Contraseña',
          ),
          onSaved: (value) => {login_user.password = value.toString()},
          validator: (value) {
            if (value.isEmpty) {
              return 'Se requiere de una contraseña.';
            } else {
              return null;
            }
          },
        ));
  }

  _error() {
    if (check == false) {
      return Text(' X');
    } else
      return Text('jh');
  }

  Widget _createBottom(BuildContext context) {
    return RaisedButton(
      child: Container(
          width: size.width * 0.65,
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Iniciar Sesión',
                ),
              ])),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      elevation: 2.0,
      color: Colors.black,
      textColor: Colors.white,
      onPressed: () => _logIn(),
    );
  }

  _logIn() async {
    try {
      setState(() {
        check = !check;
      });

      if (!formkey.currentState.validate()) {
        utils.showTopSnackBar(context, size, 'Ingrese sus credenciales',
            'Credenciales obligatorias.', utils.alertsStyles['warningAlert']);
        setState(() {
          check = !check;
        });
        return;
      }

      formkey.currentState.save();
      final resp = await auth.login(login_user.email, login_user.password);

      if (!resp) {
        utils.showTopSnackBar(context, size, '¡Algo ha fallado!.',
            'Verifique sus credenciales.', utils.alertsStyles['warningAlert']);
        setState(() {
          check = true;
        });
      }

      if (resp) {
        await auth.stateAuth();
        if (auth.authState) {
          Response responseInfoUser = await dio.get(
              '${Enviroment.apiurl}/user/profile/${FirebaseAuth.instance.currentUser.uid}',
              options: Options(headers: {
                HttpHeaders.contentTypeHeader: "application/json"
              }));
          Map<String, dynamic> userData =
              jsonDecode(responseInfoUser.toString());
          await auth.setUserStorage(userData);
          final state = await auth.storage.getValue('state');
          if (state == "1") {
            Navigator.popAndPushNamed(context, 'tips');
          } else {
            Navigator.popAndPushNamed(context, "home");
          }
          setState(() {
            check = !check;
          });
        }
      } else if (!FirebaseAuth.instance.currentUser.emailVerified) {
        setState(() {
          check = !check;
        });
        _alert['title'] = 'Verificación de correo';
        _alert['content'] =
            'Tu correo aun no ha sido verificado, para iniciar sesión verifica tu correo.';
        actions = [
          FlatButton(
              onPressed: () async {
                await auth.signOut();
                Navigator.pop(context);
              },
              child: Text('Ok')),
          FlatButton(
              onPressed: () async {
                _sendingEmail = true;
                setState(() {});
                if (FirebaseAuth.instance.currentUser != null) {
                  await auth.sendEmailVerification();
                  _sendingEmail = false;
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: _sendingEmail
                  ? CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : Text('Reenviar verificacion.')),
        ];
        setState(() {});
        showDialog(
          context: context,
          builder: (_) => alert(_alert['title'], _alert['content'], actions),
        );
      }
    } catch (e) {
      setState(() {
        check = !check;
      });
    }
  }

  AlertDialog alert(String title, String content, List<Widget> actions) =>
      AlertDialog(
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5)),
        content: Text(
          content,
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontFamily: 'Montserrat', color: Colors.grey[600], fontSize: 13),
        ),
        actions: actions,
        elevation: 24.0,
        contentPadding:
            EdgeInsets.only(right: 25.0, left: 25.0, bottom: 1.0, top: 15.0),
      );
}
