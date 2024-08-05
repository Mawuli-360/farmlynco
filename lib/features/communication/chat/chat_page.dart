import 'package:farmlynco/features/communication/chat/chat_service.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
// Import other necessary packages

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage(
      {super.key, required this.chatRoomID, required this.receiverEmail});

  final String chatRoomID;
  final String receiverEmail;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final ChatService chatService = ChatService();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _recordedAudioPath;
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isPlaying = false;
  String? _currentlyPlayingUrl;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _player.openPlayer();
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder.openRecorder();
  }

  Future<void> _playAudio(String url) async {
    if (_isPlaying && url == _currentlyPlayingUrl) {
      await _player.stopPlayer();
      setState(() {
        _isPlaying = false;
        _currentlyPlayingUrl = null;
      });
    } else {
      setState(() {
        _isPlaying = true;
        _currentlyPlayingUrl = url;
      });
      await _player.startPlayer(
        fromURI: url,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
            _currentlyPlayingUrl = null;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _player.closePlayer();
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      _recordedAudioPath = '${tempDir.path}/audio_message.aac';
      await _recorder.startRecorder(
        toFile: _recordedAudioPath,
        codec: Codec.aacADTS,
      );
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      showToast('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });
      // Send the voice message
      if (_recordedAudioPath != null) {
        await chatService.sendVoiceMessage(
            widget.chatRoomID, _recordedAudioPath!);
      }
    } catch (e) {
      showToast('Error stopping recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.receiverEmail,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildVoiceInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: chatService.getMessages(widget.chatRoomID),
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
    bool isCurrentUser = data['senderId'] == chatService.getCurrentUser()!.uid;

    if (data['type'] == 'voice') {
      return _buildVoiceMessageItem(data['audioUrl'], isCurrentUser);
    } else {
      // Handle text messages as before
      return ChatBubble(
        message: data["message"],
        isCurrentUser: isCurrentUser,
      );
    }
  }

  Widget _buildVoiceMessageItem(String audioUrl, bool isCurrentUser) {
    bool isPlaying = _isPlaying && audioUrl == _currentlyPlayingUrl;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () => _playAudio(audioUrl),
            ),
            Text(
              'Voice Message',
              style: TextStyle(
                fontFamily: 'NotoSans',
                color: isCurrentUser ? Colors.blue[800] : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInput() {
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
            child: GestureDetector(
              onLongPress: _startRecording,
              onLongPressEnd: (_) => _stopRecording(),
              child: Container(
                height: 50,
                color: _isRecording
                    ? Colors.red.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                child: Center(
                  child: Text(_isRecording ? 'Recording...' : 'Hold to record'),
                ),
              ),
            ),
          ),
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
            fontFamily: 'NotoSans',
            color: isCurrentUser ? Colors.blue[800] : Colors.black87,
          ),
        ),
      ),
    );
  }
}
