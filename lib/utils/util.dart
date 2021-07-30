//import 'package:runxatruch_app/pages/account_pages.dart';

//verificando que sean tipo numerico

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

//verificando correo

RegExp regExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool validatorEmail(String c) {
  if (regExp.hasMatch(c)) {
    return true;
  } else {
    return false;
  }
}

//verificar telefono
bool numberTel(String tel) {
  if (tel.length < 8 || !isNumeric(tel.substring(0))) {
    return false;
  } else {
    return true;
  }
}

//validar clave
RegExp regExp2 = RegExp(r'^(?=\w*\d)(?=\w*[a-z])\S{8,16}$');

bool passwordValid(String pass) {
  if (!regExp2.hasMatch(pass)) {
    return false;
  } else {
    return true;
  }
}

showSnacbar(Text error, Color color, BuildContext context) {
  var snackBar = SnackBar(
    backgroundColor: color,
    content: error,
    duration: Duration(milliseconds: 600),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
