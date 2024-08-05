import 'dart:convert';
import 'package:farmlynco/features/farmer/domain/chat_domain/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final String _chatApiUrl =
      "https://newtonapi-f45t.onrender.com/agriculture-chatbot";

  Future<String> sendMessage(String messageText) async {
    final response = await http.post(
      Uri.parse(_chatApiUrl),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: Uri.encodeFull("query=$messageText"),
    );

    return jsonDecode(response.body)['response'];
  }

  

  Future<void> saveMessages(List<Messages> messages) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> messagesJson =
        messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('chat_messages', messagesJson);
  }

  Future<List<Messages>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? messagesJson = prefs.getStringList('chat_messages');
    if (messagesJson != null) {
      return messagesJson
          .map((json) => Messages.fromJson(jsonDecode(json)))
          .toList();
    }
    return [];
  }

  Future<void> clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
  }
}
