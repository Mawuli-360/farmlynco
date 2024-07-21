import 'dart:convert';
import 'package:farmlynco/features/farmer/domain/chat_domain/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  static const String _messagesKey = 'chatMessages';

  Future<List<Messages>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString(_messagesKey);
    if (messagesJson == null) {
      return [];
    }
    List<dynamic> messagesList = json.decode(messagesJson);
    return messagesList.map((json) => Messages.fromJson(json)).toList();
  }

  Future<void> saveMessages(List<Messages> messages) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> messagesJson =
        messages.map((message) => message.toJson()).toList();
    await prefs.setString(_messagesKey, json.encode(messagesJson));
  }

  Future<void> clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_messagesKey);
  }

  Future<String> fetchChatResponse(String messageText) async {
    final response = await http.post(
      Uri.parse("https://newtonapi-f45t.onrender.com/agriculture-chatbot"),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: Uri.encodeFull(
        "query=$messageText",
      ),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['response'];
    } else {
      throw Exception('Failed to fetch chat response');
    }
  }
}
