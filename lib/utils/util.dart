import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';

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

showSnacbar(Text error, Color color, Icon icon, BuildContext context) {
  showTopSnackBar(
    context,
    Container(
      height: 60,
      child: CustomSnackBar.success(
        textStyle: error.style,
        icon: icon,
        backgroundColor: color,
        message: error.data,
      ),
    ),
  );
}
