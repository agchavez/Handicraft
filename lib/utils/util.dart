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
    icon: Icon(Icons.close, color: Colors.white),
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
      fontColor: Colors.black, backgroundColor: Colors.white),
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

void modal(
    BuildContext context, double height, List<Map<String, dynamic>> options) {
  Size size = MediaQuery.of(context).size;
  List<Widget> _list = [
    Center(
      child: Container(
        margin: EdgeInsets.only(top: 8),
        width: size.width * 0.2,
        height: 2,
        color: Colors.black,
      ),
    )
  ];
  for (var item in options) {
    _list.add(ListTile(
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        leading: item["icon"],
        title: item["title"],
        onTap: () {
          item["fnc"]();
        }));
  }
  showModalBottomSheet(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)), // <-- Radius
      ),
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: size.height * height,
            child: new Wrap(children: _list),
          ),
        );
      });
}

void showTopSnackBar(BuildContext context, Size size, String title,
        String message, AlertNotificationModel alertStyle) =>
    Flushbar(
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
