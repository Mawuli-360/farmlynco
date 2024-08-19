import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showExitDialog(bool didPop, BuildContext context) {
  if (didPop) {
    return;
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure?'),
      content: const CustomText(
        body: 'Do you want to exit the app',
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 50, 110, 52),
                    borderRadius: BorderRadius.circular(10.h)),
                padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 5.h),
                child: const CustomText(
                  body: "NO",
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => SystemNavigator.pop(),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 165, 32, 22),
                    borderRadius: BorderRadius.circular(10.h)),
                padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 5.h),
                child: const CustomText(
                  body: "Yes",
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
