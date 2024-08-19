import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomCache {
  static Future<void> saveChatRooms(List<Map<String, dynamic>> chatRooms) async {
    final prefs = await SharedPreferences.getInstance();
    final convertedChatRooms = _convertTimestamps(chatRooms);
    await prefs.setString('cachedChatRooms', jsonEncode(convertedChatRooms));
  }

  static Future<List<Map<String, dynamic>>> getCachedChatRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('cachedChatRooms');
    if (jsonString != null) {
      List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => _convertToTimestamp(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  static dynamic _convertTimestamps(dynamic value) {
    if (value is Timestamp) {
      return value.millisecondsSinceEpoch;
    } else if (value is Map) {
      return value.map((key, value) => MapEntry(key, _convertTimestamps(value)));
    } else if (value is List) {
      return value.map((v) => _convertTimestamps(v)).toList();
    }
    return value;
  }

  static Map<String, dynamic> _convertToTimestamp(Map<String, dynamic> item) {
    return item.map((key, value) {
      if (key == 'lastMessageTime' && value is int) {
        return MapEntry(key, Timestamp.fromMillisecondsSinceEpoch(value));
      }
      return MapEntry(key, value);
    });
  }
}