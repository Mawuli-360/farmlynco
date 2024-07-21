import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadImageBox extends StatelessWidget {
  const UploadImageBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 110.h,
        width: 210.w,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 100.h,
                width: 200.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 29, 182, 156),
                    Color.fromARGB(255, 17, 241, 241)
                  ]),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 36.h,
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.primaryColor,
                      size: 40.h,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 18.h,
                child: Icon(
                  Icons.edit,
                  color: AppColors.white,
                  size: 20.h,
                ),
              ),
            ),
          ],
        ));
  }
}
