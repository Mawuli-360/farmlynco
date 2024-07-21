import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWithButton extends StatelessWidget {
  const TextWithButton(
      {super.key,
      required this.text,
      required this.buttonText,
      this.onPressed,
      this.fontSize = 16});

  final String text;
  final String buttonText;
  final void Function()? onPressed;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.black, fontSize: fontSize?.sp),
        ),
        TextButton(
            onPressed: onPressed,
            style:
                ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero)),
            child: Text("Sign in",
                style:
                    TextStyle(color: AppColors.primaryColor, fontSize: 16.sp)))
      ],
    );
  }
}
