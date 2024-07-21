import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.body,
    this.fontSize = 18,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
    this.textOverflow,
    this.color,
    this.fontFamily,
    this.left = 0,
    this.bottom = 0,
    this.right = 0,
    this.top = 0,
    this.fontStyle,
  });

  final String body;
  final double fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final Color? color;
  final String? fontFamily;
  final double left;
  final double top;
  final double right;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left.h, top.h, right.h, bottom..h),
      child: Text(
        body,
        textAlign: textAlign,
        maxLines: maxLines,
        style: TextStyle(
            overflow: textOverflow,
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize.sp,
            fontStyle: fontStyle,
            fontFamily: fontFamily ?? 'Poppins'),
      ),
    );
  }
}
