import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmlynco/features/communication/chat/chat_service.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  final String receiverEmail;
  final String receiverID;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  String selectedLanguage = 'en-tw';
  List<String> languages = [
    'en-tw',
    'tw-en',
  ];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }
    await chatService.sendMessage(widget.receiverID, messageController.text);
    messageController.clear();
  }

  Future<String> translateText(String text, String targetLanguage) async {
    const apiUrl = 'https://translation-api.ghananlp.org/v1/translate';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache',
        'Ocp-Apim-Subscription-Key': dotenv.env['API_KEY'] ?? ''
      },
      body: json.encode({"in": text, "lang": targetLanguage}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to translate text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.receiverEmail,
        actions: [
          DropdownButton<String>(
            value: selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                selectedLanguage = newValue!;
              });
            },
            items: languages.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = chatService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const CustomText(body: "Error...");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomText(body: "Loading...");
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == chatService.getCurrentUser()!.uid;

    if (isCurrentUser) {
      // For outgoing messages, don't translate
      return ChatBubble(
        message: data["message"],
        isCurrentUser: true,
      );
    } else {
      // For incoming messages, translate
      return FutureBuilder<String>(
        future: translateText(data["message"], selectedLanguage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ChatBubble(
            message: snapshot.data ?? data["message"],
            isCurrentUser: false,
          );
        },
      );
    }
  }

  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isCurrentUser ? Colors.blue[800] : Colors.black87,
          ),
        ),
      ),
    );
  }
}
