import 'package:flutter/material.dart';
import 'package:handicraft_app/models/login_user.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/utils/alerts.dart';
import 'package:handicraft_app/utils/util.dart' as utils;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final formkey = GlobalKey<FormState>();

bool _showpasword = true, check = false;
LoginAccountModel login_user = new LoginAccountModel();

class _LoginPageState extends State<LoginPage> {
  Size size = Size(1000, 5000);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(child:
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 25.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, 'home');
                      },
                      child: Image.asset('assets/icons/back-black-icon.png', width: 10.0),
                    )
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.12,
            ),
            _logo(),
            SizedBox(
              height: size.height * 0.06,
            ),
            _form(),
            SizedBox(
              height: 10,
            ),
            !check
                ? _createBottom(context)
                : CircularProgressIndicator(
                    color: Colors.black,
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
                "Al hacer clic en iniciar sesión o continuar con google, acepta los términos de uso de Handicraft y política de privacidad.",
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
            } else {
              return null;
            }
          },
        ));
  }

  Widget _password() {
    bool ban = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: size.width * 0.75,
            child: TextFormField(
              obscureText: _showpasword,
              style: TextStyle(decorationColor: Colors.white),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 2.5,
                    color: Colors.black,
                  ),
                ),
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
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 100, color: Colors.white10),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: 'Contraseña',
              ),
              onSaved: (login) => login_user.password = login,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Correo electrónico';
                } else {
                  return null;
                }
              },
            )),
      ],
    );
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
    setState(() {
      check = !check;
    });

    if (!formkey.currentState.validate()) {
      setState(() {
        check = !check;
      });
      return;
    }

    formkey.currentState.save();
    final authService = Provider.of<AuthService>(context, listen: false);
    final resp = await authService.login(login_user.email, login_user.password);

    setState(() {
      check = !check;
    });

    if (resp) {
      Navigator.popAndPushNamed(context, "home");
    } else {
      showAlert(
          context, "Error", "Datos incorrectos - Verifique la informacion");
    }
  }
}
