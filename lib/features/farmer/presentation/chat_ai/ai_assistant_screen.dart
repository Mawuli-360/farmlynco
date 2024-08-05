import 'package:farmlynco/features/farmer/presentation/chat_ai/component/message_widget.dart';
import 'package:farmlynco/features/farmer/presentation/chat_ai/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../shared/common_widgets/custom_appbar.dart';
import '../../../../shared/common_widgets/custom_text.dart';

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final TextEditingController promptController = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(chatProvider.notifier).initSpeech();
    ref.read(chatProvider.notifier).loadMessages();
  }

  @override
  void dispose() {
    promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final chatNotifier = ref.read(chatProvider.notifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Rice Farmer Chatbot",
        actions: [
          IconButton(
              onPressed: () => chatNotifier.clearChatHistory(),
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 25.h,
              ))
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            chatState.speechEnabled && chatState.speechToText.isListening
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 180.h,
                            width: 180.h,
                            child:
                                Lottie.asset("assets/animations/listen.json")),
                        Text(
                          chatState.lastWords,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: chatState.messages.isEmpty
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Container(
                      color: const Color.fromARGB(248, 13, 59, 51),
                      width: double.infinity,
                      child: chatState.messages.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.h),
                              child: SizedBox(
                                height: 65.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/chatbot.png",
                                      width: 200.h,
                                    ),
                                    const CustomText(
                                      body: "How can we help you today?",
                                      fontSize: 18,
                                      color: AppColors.white,
                                    ),
                                    20.verticalSpace,
                                    Container(
                                      height: 65.h,
                                      width: 350.h,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.transparent,
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              body: "Powered by AI",
                                              fontSize: 17,
                                              color: AppColors.white,
                                            ),
                                            CustomText(
                                              body:
                                                  "-Example: How to grow rice?",
                                              fontSize: 15,
                                              color: AppColors.white,
                                            ),
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount:
                                        chatState.groupedMessages.length +
                                            (chatState.isTyping ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index ==
                                              chatState
                                                  .groupedMessages.length &&
                                          chatState.isTyping) {
                                        // This is the last item, and we're typing, so show the loading animation
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Lottie.asset(
                                                "assets/animations/loading.json",
                                                height: 40.h,
                                                width: 40.w),
                                          ],
                                        );
                                      }

                                      // Otherwise, show the grouped messages as before
                                      final groupedMessage =
                                          chatState.groupedMessages[index];
                                      return Column(
                                        children: [
                                          // Date header
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h),
                                            child: Text(
                                              groupedMessage.date,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          // Messages for this date
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                groupedMessage.messages.length,
                                            itemBuilder:
                                                (context, messageIndex) {
                                              final message = groupedMessage
                                                  .messages[messageIndex];
                                              return MessageWidget(
                                                  message: message);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
            Container(
              height: 80.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xDCFFFFFF).withOpacity(.4),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onLongPress: () {
                        chatNotifier.startListening();
                      },
                      onLongPressUp: () {
                        chatNotifier.stopListening();
                        chatNotifier.sendVoiceMessage();
                      },
                      child: Container(
                          height: 45.h,
                          width: 45.h,
                          decoration: const BoxDecoration(
                              color: AppColors.headerTitleColor,
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.mic,
                            color: AppColors.white,
                          ))),
                  Container(
                    width: 260.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: AppColors.headerTitleColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Form(
                        key: _formKey,
                        child: TextField(
                          cursorColor: AppColors.white,
                          style: TextStyle(
                              fontSize: 16.sp, color: AppColors.white),
                          maxLines: 4,
                          minLines: 1,
                          controller: promptController,
                          focusNode: _textFieldFocusNode,
                          decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 16.sp, color: AppColors.white),
                              hintText: "Send Message"),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        _textFieldFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(FocusNode());
                        chatNotifier.sendMessage(promptController.text);
                        promptController.clear();
                      },
                      child: Container(
                          height: 45.h,
                          width: 45.h,
                          decoration: const BoxDecoration(
                              color: AppColors.headerTitleColor,
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.send,
                            color: AppColors.white,
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
