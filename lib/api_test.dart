import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Sending a chat request...');
  final url = Uri.parse('http://10.0.2.2:3000/chat');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'userInput': 'User input goes here'});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print('Chat request sent successfully');
  } else {
    print('Failed to send chat request');
  }
  print('Response: ${response.body}');
}
