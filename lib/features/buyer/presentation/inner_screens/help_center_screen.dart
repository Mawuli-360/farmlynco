import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Help Center"),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                20.verticalSpace,
                Lottie.asset("assets/animations/help_center.json"),
                20.verticalSpace,
                const CustomText(
                  body:
                      "We are here to help you get the most out of your experience with our app. Let us know how we can assist with all of your questions and issues!",
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                20.verticalSpace,
                TextFormField(
                  minLines: 5,
                  maxLines: 6,
                  cursorColor: AppColors.green,
                  decoration: const InputDecoration(
                    hintText: "Write a report to us...",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.green)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.green)),
                  ),
                ),
                40.verticalSpace,
                PrimaryButton(
                  onTap: () {},
                  text: "Submit report",
                  textColor: Colors.white,
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      )),
    );
  }
}
