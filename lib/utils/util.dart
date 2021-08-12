
//import 'package:runxatruch_app/pages/account_pages.dart';

//verificando que sean tipo numerico

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:handicraft_app/models/alert_notification_model.dart';

Map<String, AlertNotificationModel> alertsStyles = {
  "fatalError": AlertNotificationModel(
    fontColor: Colors.white,
    backgroundColor: Colors.redAccent,
    icon: Icon(
      Icons.close, color: Colors.white
    ),
  ),
  "warningAlert": AlertNotificationModel(
    fontColor: Colors.white,
    backgroundColor: Colors.amber,
    icon: Icon(Icons.warning, color: Colors.white),
  ),
  "successAlert": AlertNotificationModel(
    fontColor: Colors.white,
    backgroundColor: Colors.blueAccent,
    icon: Icon(Icons.check, color: Colors.white),
  ),
  "notificationAlertBlack": AlertNotificationModel(
    fontColor: Colors.white,
    backgroundColor: Colors.black,
  ),
  "notificationAlertWhite": AlertNotificationModel(
    fontColor: Colors.black,
    backgroundColor: Colors.white
  ),
};

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

RegExp regExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool validatorEmail(String c) {
  if (regExp.hasMatch(c)) {
    return true;
  } else {
    return false;
  }
}

bool numberTel(String tel) {
  if (tel.length < 8 || !isNumeric(tel.substring(0))) {
    return false;
  } else {
    return true;
  }
}

RegExp regExp2 = RegExp(r'^(?=\w*\d)(?=\w*[a-z])\S{8,16}$');

bool passwordValid(String pass) {
  if (!regExp2.hasMatch(pass)) {
    return false;
  } else {
    return true;
  }
}

void showTopSnackBar(BuildContext context, Size size, String title, String message, AlertNotificationModel alertStyle) => Flushbar(
  shouldIconPulse: false,
  icon: alertStyle.icon == null ? null : alertStyle.icon,
  duration: Duration(seconds: 4),
  isDismissible: true,
  title: title,
  message: message,
  padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
  flushbarPosition: FlushbarPosition.TOP,
  borderRadius: 10,
  animationDuration: Duration(seconds: 0),
  margin: EdgeInsets.only(left: 15, right: 15, top: size.width * 0.15),
  backgroundColor: alertStyle.backgroundColor,
  dismissDirection: FlushbarDismissDirection.HORIZONTAL,
)..show(context);

showSnacbar(Text error, Color color, BuildContext context) {
  var snackBar = SnackBar(
    backgroundColor: Color(0xffFFD414),
    content: error,
    duration: Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
=======
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

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
