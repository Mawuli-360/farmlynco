import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreenData {
  LanguageScreenData._();

  static List<LanguageOption> languageOption = [
    LanguageOption(title: "English", languageCode: "en"),
    LanguageOption(title: "French", languageCode: "fr"),
    LanguageOption(title: "Ewe", languageCode: "ee"),
    LanguageOption(title: "Twi", languageCode: "tw"),
  ];
}

class LanguageOption {
  final String title;
  final String? languageCode;

  LanguageOption({required this.title, required this.languageCode});
}

class LanguageTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final bool isSelected;

  const LanguageTile(
      {super.key,
      required this.onTap,
      required this.title,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            color: isSelected
                ? const Color.fromARGB(83, 136, 219, 193)
                : AppColors.white,
            borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            1.horizontalSpace,
            Text(
              title,
              style: TextStyle(fontSize: 18.sp),
            ),
            isSelected
                ? Container(
                    height: 25.h,
                    width: 25.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16.h,
                    ),
                  )
                : Icon(
                    Icons.circle_outlined,
                    color: AppColors.primaryColor,
                    size: 28.h,
                  ),
            10.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
