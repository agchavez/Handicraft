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
          bottomOpacity: 0.0,
          elevation: 0.0,
          title:  Text(
            'Chats',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold
            ),
          )),
    );
  }
}
