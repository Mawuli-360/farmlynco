import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      this.height,
      this.width,
      required this.onTap,
      this.fontWeight,
      this.color,
      this.fontSize,
      this.textColor,
      this.borderColor = Colors.transparent,
      this.child,
      required this.text,
      this.space,
      this.useStadiumBorder = true,
      this.childAtStart = false});

  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final Color? textColor;
  final Color borderColor;
  final Widget? child;
  final String text;
  final double? space;
  final bool useStadiumBorder;
  final bool childAtStart;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 50.h,
        width: width ?? double.infinity,
        decoration: ShapeDecoration(
          color: color ?? AppColors.green,
          shape: useStadiumBorder
              ? StadiumBorder(side: BorderSide(color: borderColor))
              : RoundedRectangleBorder(
                  side: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(10.r),
                ),
        ),
        child: child == null
            ? Center(
                child: CustomText(
                  body: text,
                  fontSize: fontSize ?? 16,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (childAtStart) child!,
                  if (childAtStart)
                    space?.horizontalSpace ?? 10.horizontalSpace,
                  CustomText(
                    body: text,
                    fontSize: fontSize ?? 16,
                    color: textColor,
                  ),
                  if (!childAtStart)
                    space?.horizontalSpace ?? 10.horizontalSpace,
                  if (!childAtStart) child!
                ],
              ),
      ),
    );
  }
}

// 

