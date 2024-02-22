import 'package:flutter/material.dart';
import 'package:smile_front/screen/part1/result_screen.dart';
import '../../chat/message_show.dart';
import '../../chat/message_send.dart';

class DepressionChatbotScreen extends StatefulWidget {
  const DepressionChatbotScreen({Key? key}) : super(key: key);

  @override
  State<DepressionChatbotScreen> createState() => _DepressionChatbotScreenState();
}

class _DepressionChatbotScreenState extends State<DepressionChatbotScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅을 통한 우울증 진단'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.assessment),
            onPressed: () {
              // 결과 페이지로 넘어가는 로직
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResultScreen()), // 가상의 결과 스크린
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),  // 메시지 목록을 표시합니다.
            ),
            NewMessage(),  // 새 메시지 입력 필드를 표시합니다.
          ],
        ),
      ),
    );
  }
}