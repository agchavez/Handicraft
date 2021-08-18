import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/chat_model.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/provider/chat_provider.dart';
import 'package:handicraft_app/widgets/body_chats.dart';
import 'package:provider/provider.dart';

class MenssagePages extends StatefulWidget {
  @override
  _MenssagePagesState createState() => _MenssagePagesState();
}

class _MenssagePagesState extends State<MenssagePages> {
  ChatService  chatService;
  AuthService auth;

  @override
  void initState() {
    auth = Provider.of<AuthService>(context, listen: false);
    if ( FirebaseAuth.instance.currentUser != null ) {
      chatService = Provider.of<ChatService>(context, listen: false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(),
      body: Body()
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      elevation: 0,
      title: Text(
        "Mensajes",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontFamily: 'Montserrat'
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
          },
          color: Colors.white,
        ),
      ],
    );
  }
}

