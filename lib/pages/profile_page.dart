import 'package:flutter/material.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:handicraft_app/provider/auth_service.dart';

class PorfilePage extends StatelessWidget {
  @override
  Size size;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  AuthService().signOut();
                  StorageService().setValue("", "uid");
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
          ),
        ),
        body: _createBody());
  }

  Widget _createBody() {}
}
