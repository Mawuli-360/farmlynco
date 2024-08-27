import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/communication/chat/chat_service.dart';
import 'package:farmlynco/features/communication/chat/model/audio_cache.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage(
      {super.key, required this.chatRoomID, required this.receiverName});

  final String chatRoomID;
  final String receiverName;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final ChatService chatService = ChatService();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  String? _recordedAudioPath;
  bool _isPlaying = false;
  String? _currentlyPlayingUrl;
  bool _isRecording = false;
  Map<String, Duration> audioDurations = {};
  Map<String, Duration> audioPositions = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
    _preCacheAudioFiles();
  }

  Future<void> _preCacheAudioFiles() async {
    final messages = await chatService.getInitialMessages(widget.chatRoomID);
    for (var message in messages) {
      if (message['type'] == 'voice') {
        AudioCache.getCachedAudioPath(message['audioUrl']);
      }
    }
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
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isPlaying && url == _currentlyPlayingUrl) {
        await _player.stopPlayer();
        setState(() {
          _isPlaying = false;
          _currentlyPlayingUrl = null;
        });
      } else {
        final cachedPath = await AudioCache.getCachedAudioPath(url);
        setState(() {
          _isPlaying = true;
          _currentlyPlayingUrl = url;
        });
        await _player.startPlayer(
          fromURI: cachedPath,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
              _currentlyPlayingUrl = null;
            });
          },
        );

        // Track audio duration and position
        _player.onProgress!.listen((event) {
          setState(() {
            audioDurations[url] = event.duration;
            audioPositions[url] = event.position;
          });
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        title: widget.receiverName,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AppImages.sa, fit: BoxFit.fill)),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildVoiceInput(),
          ],
        ),
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
            padding: EdgeInsets.all(15.h),
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
      return _buildTextMessageItem(data['message'], isCurrentUser);
    }
  }

  Widget _buildTextMessageItem(String message, bool isCurrentUser) {
    return BubbleNormal(
      text: message,
      isSender: isCurrentUser,
      color: isCurrentUser ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
      tail: true,
      textStyle: TextStyle(
        fontFamily: 'NotoSans',
        color: isCurrentUser ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
    );
  }

  Widget _buildVoiceMessageItem(String audioUrl, bool isCurrentUser) {
    bool isPlaying = _isPlaying && audioUrl == _currentlyPlayingUrl;
    bool isLoading = _isLoading && audioUrl == _currentlyPlayingUrl;
    double duration =
        audioDurations[audioUrl]?.inMilliseconds.toDouble() ?? 0.0;
    double position =
        audioPositions[audioUrl]?.inMilliseconds.toDouble() ?? 0.0;

    return BubbleNormalAudio(
      duration: duration / 1000,
      position: position / 1000,
      isPlaying: isPlaying,
      isLoading: isLoading,
      isPause: !isPlaying && !isLoading,
      onSeekChanged: (double value) {
        final newPosition = Duration(milliseconds: (duration * value).toInt());
        _player.seekToPlayer(newPosition);
      },
      onPlayPauseButtonClick: () => _playAudio(audioUrl),
      color: isCurrentUser ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
      isSender: isCurrentUser,
    );
  }

  Widget _buildVoiceInput() {
    return MessageBar(
      onSend: (String message) async {
        if (message.trim().isNotEmpty) {
          await chatService.sendMessage(widget.chatRoomID, message);
        }
      },
      actions: [
        GestureDetector(
          onLongPress: _startRecording,
          onLongPressEnd: (_) => _stopRecording(),
          child: Icon(
            _isRecording ? Icons.mic : Icons.mic_none,
            color: _isRecording ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}
