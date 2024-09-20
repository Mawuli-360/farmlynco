import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/domain/chat_domain/message_model.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageWidget extends StatelessWidget {
  final Messages message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: message.sender == Sender.user
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Bubble(
          margin: BubbleEdges.only(bottom: 15.h, left: 10.h, right: 10.h),
          color: message.sender == Sender.user
              ? const Color.fromARGB(255, 64, 121, 92)
              : AppColors.primaryColor,
          borderColor: AppColors.white,
          showNip: true,
          nip: message.sender == Sender.user
              ? BubbleNip.rightBottom
              : BubbleNip.leftBottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.sender == Sender.bot)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.77,
                  ),
                  child: MarkdownBody(
                    data: message.text,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: 16.sp, color: Colors.white),
                      h1: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      h2: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      h3: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      code: TextStyle(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          color: Colors.white),
                      blockquote: const TextStyle(
                          color: Colors.white70, fontStyle: FontStyle.italic),
                    ),
                    onTapLink: (text, href, title) {
                      if (href != null) {
                        launchUrl(Uri.parse(href));
                      }
                    },
                  ),
                )
              else
                Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: message.sender == Sender.user
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
