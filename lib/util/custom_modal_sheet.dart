import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCustomModalSheet(BuildContext context) {
  showModalBottomSheet(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 450.h,
            margin: EdgeInsets.all(5.h),
            decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(30.h)),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: EdgeInsets.only(right: 20.h, top: 10.h),
                    icon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.white,
                      size: 36.h,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
            // Align(
            //   alignment: Alignment.topRight,
            //   child: IconButton(
            //     icon: const Icon(
            //       Icons.keyboard_arrow_down_outlined,
            //       color: Colors.white,
            //     ),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            // ),
            );
      });
}
