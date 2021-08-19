// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:handicraft_app/provider/chat_provider.dart';
import 'package:handicraft_app/widgets/filled_outline_button.dart';
import 'package:handicraft_app/utils/constants.dart';
import 'package:handicraft_app/models/chat_model.dart';
import 'package:handicraft_app/pages/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:provider/provider.dart';
import 'chat_card.dart';
import 'package:intl/intl.dart';

class BodyMessage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyMessage> {
  AuthService auth;
  ChatService chatService;

  @override
  void initState() {
    auth = Provider.of<AuthService>(context, listen: false);
    if ( FirebaseAuth.instance.currentUser != null ) {
      chatService = Provider.of<ChatService>(context, listen: false);
      getMessages();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(
                  true,
                      () {},
                  "Todos"),
              SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                  false,
                      () {},
                  "Sin leer"
              ),
            ],
          ),
        ),
        StreamBuilder(
            stream: chatService.getMessages(FirebaseAuth.instance.currentUser.uid),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(color: Colors.black),
                      width: 18,
                      height: 18,
                    )
                  );
                }

                DateTime now = new DateTime.now();
                DateTime date = new DateTime(now.year, now.month, now.day);
                String currentDate = DateFormat('dd/MM/yyyy').format(date);
                List<dynamic> chats = snapshot.data.docs.map((doc) {
                String messageDate = DateFormat('dd/MM/yyyy').format((doc['time'] as Timestamp).toDate());
                if (messageDate == currentDate) {
                    messageDate = DateFormat('hh:mm a').format((doc['time'] as Timestamp).toDate());
                }

                return Chat(
                     name: doc['name'],
                     lastMessage: doc['lastMessage'],
                     time: messageDate,
                     read: doc['read'],
                     image: doc['image'],
                     isActive: doc['isActive'],
                   );
                 }).toList();

                 return Expanded(child:
                  ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) => ChatCard(
                        chats[index],
                        () => Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context)
                        => MessagesScreen())),
                ),
                )
              );
            },
          ),
      ],
    );
  }

  Future<void> getMessages() async {
    await chatService.getMessages( FirebaseAuth.instance.currentUser.uid );
  }
}
