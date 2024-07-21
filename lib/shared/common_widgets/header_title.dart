import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    super.key,
    required this.title,
    this.fontSize,
    this.fontWeight,
    this.onPressed,
    this.fontFamily,
    this.fontColor,
    this.horizontalSpace,
  });

  final String title;
  final double? fontSize;
  final double? horizontalSpace;
  final FontWeight? fontWeight;
  final Function()? onPressed;
  final String? fontFamily;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalSpace?.r ?? 15.r),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: fontSize?.sp ?? 18.sp,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  fontFamily: fontFamily,
                  color: fontColor ?? AppColors.headerTitleColor,
                )),
            TextButton(
                onPressed: onPressed,
                style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero)),
                child: CustomText(
                  body: "view all",
                  color: AppColors.primaryColor,
                  fontSize: 17.sp,
                ))
          ],
        ),
      ),
    );
  }
}
