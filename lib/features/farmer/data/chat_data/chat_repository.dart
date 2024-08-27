import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

  Future<String> 
  fetchChatResponse(String messageText) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                "https://newtonapi-f45t.onrender.com/agriculture-chatbot"),
            headers: {
              "accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: Uri.encodeFull(
              "query=$messageText",
            ),
          )
          .timeout(const Duration(seconds: 10)); // Add a timeout of 10 seconds

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['response'];
      } else {
        return "Error occurred while fetching data. Status code: ${response.statusCode}";
      }
    } on SocketException catch (_) {
      return "Bad network connection. Please check your internet and try again.";
    } on TimeoutException catch (_) {
      return "Request timed out. Please try again later.";
    } catch (e) {
      return "An error occurred while fetching data: ${e.toString()}";
    }
  }
}
