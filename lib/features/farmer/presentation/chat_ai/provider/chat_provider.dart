
import 'package:farmlynco/core/extension/date_helper.dart';
import 'package:farmlynco/features/farmer/domain/chat_domain/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/chat_data/chat_repository.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

// Define the ChatRepository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

class ChatState {
  final List<Messages> messages;
  final List<GroupedMessages> groupedMessages;
  final bool isTyping;
  final bool speechEnabled;
  final String lastWords;
  final SpeechToText speechToText;

  ChatState({
    required this.messages,
    required this.groupedMessages,
    required this.isTyping,
    required this.speechEnabled,
    required this.lastWords,
    required this.speechToText,
  });

  ChatState copyWith({
    List<Messages>? messages,
    List<GroupedMessages>? groupedMessages,
    bool? isTyping,
    bool? speechEnabled,
    String? lastWords,
    SpeechToText? speechToText,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      groupedMessages: groupedMessages ?? this.groupedMessages,
      isTyping: isTyping ?? this.isTyping,
      speechEnabled: speechEnabled ?? this.speechEnabled,
      lastWords: lastWords ?? this.lastWords,
      speechToText: speechToText ?? this.speechToText,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository chatRepository;

  ChatNotifier(this.chatRepository)
      : super(ChatState(
          messages: [],
          groupedMessages: [],
          isTyping: false,
          speechEnabled: false,
          lastWords: '',
          speechToText: SpeechToText(),
        )) {
    loadMessages();
    initSpeech();
  }

  Future<void> initSpeech() async {
    final speechEnabled = await state.speechToText.initialize();
    state = state.copyWith(speechEnabled: speechEnabled);
  }

  void startListening() async {
    await state.speechToText.listen(onResult: onSpeechResult);
    state = state.copyWith();
  }

  void stopListening() async {
    await state.speechToText.stop();
    state = state.copyWith();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    state = state.copyWith(lastWords: result.recognizedWords);
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.isEmpty) return;

    Messages userMessage = Messages(
      text: messageText,
      sender: Sender.user,
      timestamp: DateTime.now(),
    );

    // Add user message to state
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    final responseText = await chatRepository.fetchChatResponse(messageText);

    Messages botMessage = Messages(
      text: responseText,
      sender: Sender.bot,
      timestamp: DateTime.now(),
    );

    // Add bot message to state
    state = state.copyWith(
      messages: [...state.messages, botMessage],
      isTyping: false,
    );

    groupMessages();
    await chatRepository.saveMessages(state.messages);
  }

  Future<void> sendVoiceMessage() async {
    if (state.lastWords.isEmpty) return;

    Messages userMessage = Messages(
      text: state.lastWords,
      sender: Sender.user,
      timestamp: DateTime.now(),
    );

    // Add user message to state
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    final responseText =
        await chatRepository.fetchChatResponse(state.lastWords);

    Messages botMessage = Messages(
      text: responseText,
      sender: Sender.bot,
      timestamp: DateTime.now(),
    );

    // Add bot message to state
    state = state.copyWith(
      messages: [...state.messages, botMessage],
      isTyping: false,
      lastWords: '',
    );

    groupMessages();
    await chatRepository.saveMessages(state.messages);
  }

  void groupMessages() {
    Map<String, List<Messages>> groupedMap = {};
    for (var message in state.messages) {
      String date = _formatDate(message.timestamp);
      if (!groupedMap.containsKey(date)) {
        groupedMap[date] = [];
      }
      groupedMap[date]!.add(message);
    }

    List<GroupedMessages> groupedMessages = [];
    groupedMap.forEach((date, messages) {
      groupedMessages.add(GroupedMessages(date: date, messages: messages));
    });

    // Sort grouped messages by date (most recent first)
    groupedMessages.sort((a, b) => b.date.compareTo(a.date));

    state = state.copyWith(groupedMessages: groupedMessages);
  }

  String _formatDate(DateTime date) {
    if (date.isToday()) {
      return "Today";
    } else if (date.isYesterday()) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  Future<void> loadMessages() async {
    final messages = await chatRepository.loadMessages();
    state = state.copyWith(messages: messages);
    groupMessages();
  }

  Future<void> clearChatHistory() async {
    await chatRepository.clearChatHistory();
    state = state.copyWith(messages: [], groupedMessages: []);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(chatRepository);
});
