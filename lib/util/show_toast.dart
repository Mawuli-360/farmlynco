import 'package:farmlynco/route/navigation.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';

void showToast(String message) {
  final context = Navigation.navigatorKey.currentContext;
  if (context != null) {
    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      builder: (context) => ToastCard(
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ).show(context);
  } else {}
}


