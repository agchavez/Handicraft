import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handicraft_app/models/chat_model.dart';
import 'package:intl/intl.dart';

class ChatService with ChangeNotifier {
  List<Chat> messages = [];
  StreamController<List<Chat>> messagesStreamController = new StreamController();

  closeStream() async {
    await messagesStreamController.close();
  }

  Stream<QuerySnapshot> getMessages(String uid) {
    return FirebaseFirestore.instance.collection('chats').doc(uid)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }
}