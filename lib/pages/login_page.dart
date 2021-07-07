import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, "register");
              },
              child: Text("Register"))
        ],
      ),
    );
  }
}
