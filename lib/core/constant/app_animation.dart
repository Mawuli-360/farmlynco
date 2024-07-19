import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AppAnimation {
  AppAnimation._();

  static final searchProduct = Lottie.asset(
    "assets/animations/search_anim.json",
    height: 400.h,
    width: 400.w,
    fit: BoxFit.cover,
  );
  static final noProductFound = Lottie.asset(
    "assets/animations/no_product.json",
    height: 200.h,
    width: 200.w,
  );
}
