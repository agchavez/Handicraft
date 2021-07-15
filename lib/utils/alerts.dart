import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert(BuildContext context, String title, String subTittle) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(subTittle),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              MaterialButton(
                  child: Text(
                    "ok",
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                  elevation: 3,
                  onPressed: () => Navigator.pop(context))
            ],
          ));
}
