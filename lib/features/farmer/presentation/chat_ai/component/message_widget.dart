import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/domain/chat_domain/message_model.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; 

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
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: message.sender == Sender.user
                      ? Colors.white
                      : AppColors.white,
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
