import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 200),
        child: Center(
          child: Column(
            children: [
              Text("Home "),
              TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "login");
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
