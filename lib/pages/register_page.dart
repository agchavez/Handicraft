import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, "home");
              },
              child: Text("Home"))
        ],
      ),
    );
  }
}
