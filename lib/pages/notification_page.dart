import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Notificaciones",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: 'Montserrat'
          ),
        )
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Image.asset(
              "assets/images/who _did'nt_hi_work.gif",
              height: 200.0,
              width: 175.0,
            ),
            Text('Sección en proceso.',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
            )),
          ],
        ),
      ),
    );
  }
}
