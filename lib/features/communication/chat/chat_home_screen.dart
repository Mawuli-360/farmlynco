import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmlynco/features/communication/chat/chat_page.dart';
import 'package:farmlynco/features/communication/chat/model/chatroom_cache.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlynco/features/communication/chat/chat_service.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatHomeScreen extends ConsumerStatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  ConsumerState<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends ConsumerState<ChatHomeScreen> {
  final ChatService chatService = ChatService();
  List<Map<String, dynamic>> _cachedChatRooms = [];

  @override
  void initState() {
    super.initState();
    _loadCachedChatRooms();
  }

  Future<void> _loadCachedChatRooms() async {
    try {
      final cachedRooms = await ChatRoomCache.getCachedChatRooms();
      setState(() {
        _cachedChatRooms = cachedRooms;
      });
    } catch (e) {
      // Handle the error appropriately, maybe set _cachedChatRooms to an empty list
      setState(() {
        _cachedChatRooms = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Chat Room"),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.getChatRoomsForCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: CustomText(body: "Error..."));
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            _cachedChatRooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomLoadingScale(),
                10.verticalSpace,
                const CustomText(body: "Loading..."),
              ],
            ),
          );
        }

        final chatRooms = snapshot.data ?? _cachedChatRooms;
        if (snapshot.hasData) {
          final serializableChatRooms = chatRooms.map((room) {
            final newRoom = Map<String, dynamic>.from(room);
            if (newRoom['lastMessageTime'] is Timestamp) {
              newRoom['lastMessageTime'] =
                  (newRoom['lastMessageTime'] as Timestamp)
                      .millisecondsSinceEpoch;
            }
            return newRoom;
          }).toList();

          // Update cache when new data is available
          ChatRoomCache.saveChatRooms(serializableChatRooms);
        }

        return ListView(
          children: chatRooms
              .map<Widget>((chatRoomData) =>
                  _buildChatRoomListItem(chatRoomData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildChatRoomListItem(
      Map<String, dynamic> chatRoomData, BuildContext context) {
    final lastMessageTime = chatRoomData['lastMessageTime'] is int
        ? DateTime.fromMillisecondsSinceEpoch(chatRoomData['lastMessageTime'])
        : (chatRoomData['lastMessageTime'] as Timestamp?)?.toDate();

    return UserTile(
      text: chatRoomData['otherUserName'] ?? chatRoomData['otherUserEmail'],
      lastMessage: chatRoomData['lastMessage'],
      lastMessageTime: lastMessageTime,
      isOnline: chatRoomData['isOnline'],
      onTap: () {
        Navigation.navigatePush(ChatPage(
          chatRoomID: chatRoomData['chatRoomId'],
          receiverName: chatRoomData['otherUserName'],
        ));
      },
    );
  }
}

class UserTile extends ConsumerWidget {
  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    this.lastMessage,
    this.lastMessageTime,
    this.isOnline,
  });

  final String text;
  final void Function()? onTap;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool? isOnline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Stack(
          children: [
            const Icon(Icons.person),
            if (isOnline == true)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: CustomText(body: text),
        subtitle: lastMessage != null
            ? CustomText(body: lastMessage!, fontSize: 12)
            : null,
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lastMessageTime != null)
              CustomText(body: _formatDate(lastMessageTime!), fontSize: 10),
            if (isOnline == false && lastMessageTime != null)
              CustomText(
                  body: 'Last seen: ${_formatDate(lastMessageTime!)}',
                  fontSize: 10),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Implement your date formatting logic here
    return '${date.hour}:${date.minute}';
  }
}
