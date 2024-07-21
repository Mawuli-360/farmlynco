
import 'package:farmlynco/features/communication/chat/chat_page.dart';
import 'package:farmlynco/features/communication/chat/chat_service.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChatHomeScreen extends ConsumerWidget {
  ChatHomeScreen({super.key});

  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Chat Room"),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: chatService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const CustomText(body: "Error...");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomText(body: "Loading...");
          }

          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != chatService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigation.navigatePush(ChatPage(
            receiverEmail: userData['email'],
            receiverID: userData['uid'],
          ));
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class UserTile extends ConsumerWidget {
  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: const Icon(Icons.person),
        title: CustomText(body: text),
      ),
    );
  }
}
