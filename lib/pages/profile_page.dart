import 'package:flutter/material.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:provider/provider.dart';

AuthService auth;

class PorfilePage extends StatelessWidget {
  Size size;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut();
                Navigator.popAndPushNamed(context, "home");
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ))
        ],
        backgroundColor: Colors.white,
        title: Text(
          "Perfil",
          style: TextStyle(color: Colors.black),
        )),
        body: _createBody());
  }

  Widget _createBody() {}
}
