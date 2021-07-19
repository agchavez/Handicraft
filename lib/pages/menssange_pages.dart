import 'package:flutter/material.dart';

class MenssagePages extends StatefulWidget {
  @override
  _MenssagePagesState createState() => _MenssagePagesState();
}

class _MenssagePagesState extends State<MenssagePages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Mensajes",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
