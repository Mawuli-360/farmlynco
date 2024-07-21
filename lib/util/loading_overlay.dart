import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingOverlay {
  OverlayEntry? _overlay;

  void show(BuildContext context) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (context) => ColoredBox(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(30.h),
              decoration: BoxDecoration(
                color: const Color.fromARGB(214, 6, 6, 6),
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: SizedBox(
                height: 40.h,
                width: 40.h,
                child: const LoadingIndicator(
                  indicatorType: Indicator.lineScale,
                  colors: [AppColors.white, AppColors.headerTitleColor],
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlay!);
    }
  }

  void hide() {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }
}
