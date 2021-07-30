import 'package:flutter/material.dart';

class MenssagePages extends StatefulWidget {
  @override
  _MenssagePagesState createState() => _MenssagePagesState();
}

class _MenssagePagesState extends State<MenssagePages> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: size.height * 0.2,
        bottomOpacity: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),),
        title: Text(
          "Mensajes",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Gilroy_ExtraBold',
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
