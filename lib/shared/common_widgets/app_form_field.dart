import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:farmlynco/core/constant/app_colors.dart';

class AppFormField extends StatelessWidget {
  const AppFormField(
      {super.key,
      required this.prefixIcon,
      this.suffixIcon,
      this.height,
      required this.labelText,
      required this.hintText,
      this.isPassword = false,
      this.inputType,
      this.readOnly,
      this.onChanged,
     this.controller});

  final IconData prefixIcon;
  final Widget? suffixIcon;
  final double? height;
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextInputType? inputType;
  final bool? readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 55.h,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color.fromARGB(24, 0, 0, 0),
            spreadRadius: 2.r,
            blurRadius: 1.r,
            offset: const Offset(1, 1))
      ]),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscuringCharacter: '*',
        obscureText: isPassword,
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.primaryColor,
            ),
            labelText: labelText,
            labelStyle:
                TextStyle(fontSize: 16.sp, color: AppColors.primaryColor),
            fillColor: AppColors.white,
            filled: true,
            hintText: hintText,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            suffixIcon: suffixIcon),
      ),
    );
  }
}
