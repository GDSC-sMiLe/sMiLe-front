import 'dart:async';

import 'package:flutter/material.dart';
import 'chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  late Stream<QuerySnapshot> chatDocs;

  @override
  void initState() {
    super.initState();
    chatDocs = FirebaseFirestore.instance.collection('chat').orderBy('time', descending: true).snapshots();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    print('User: ${_controller.text}');
    FirebaseFirestore.instance.collection('chat').add({
      'chat': _controller.text,
      'isUser': true,
      'time': Timestamp.now(),
    });
    _sendChatRequest();
    _controller.clear();
  }

  // 입력받은 메세지를 api로 전송하여 답변을 만들어서 firestore에 저장
  void _sendChatRequest() async {
    print('Sending a chat request...');
    final url = Uri.parse('http://10.0.2.2:3000/chat');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'userInput': _controller.text});
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Chat request sent successfully');
    } else {
      print('Failed to send chat request');
    }
    print('Response: ${jsonDecode(response.body)['text']}');
    var chat_text = jsonDecode(response.body)['text'];
    if (chat_text == null) {
      chat_text = 'Sorry, I cannot understand...';
    }
    FirebaseFirestore.instance.collection('chat').add({
      'chat': chat_text,
      'isUser': false,
      'time': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: '메시지를 입력하세요...'),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
