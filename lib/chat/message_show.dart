import 'dart:async';

import 'package:flutter/material.dart';
import 'chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var chatDocs = _firestore.collection('chat').orderBy('time', descending: true).snapshots();

    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: chatDocs,
            builder: (context, AsyncSnapshot<QuerySnapshot> chatDocs) {
              if (chatDocs.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var chatDocsList = chatDocs.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocsList.length,
                itemBuilder: (context, index) => ChatBubbles(
                  chatDocsList[index]['chat'] as String,
                  chatDocsList[index]['isUser'] as bool,
                  //chatDocsList[index]['time'] as Timestamp
                ),
              );
            },
          ),
        ),
      ],
    );
    }
  }
