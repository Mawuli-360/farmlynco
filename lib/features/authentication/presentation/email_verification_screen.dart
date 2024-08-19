import 'dart:async';

import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen(this.user, this.auth, {super.key});

  final User user;
  final FirebaseAuth auth;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _isResendLinkAvailable = true;
  Timer? _resendTimer;
  Timer? _countdownTimer;
  int _remainingSeconds = 60;

  Future<void> continueToLogin() async {
    widget.auth.signOut();
    Navigation.navigateReplace(Navigation.loginScreen);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: 1.sh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      height: 300.h,
                      width: 300.h,
                      image: AppImages.sentEmail,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      'Please verify your email address',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    40.verticalSpace,
                    PrimaryButton(
                      onTap: _isResendLinkAvailable
                          ? () {
                              _sendVerificationEmail(widget.user);
                              _startResendTimer();
                            }
                          : null,
                      color: AppColors.white,
                      borderColor: AppColors.primaryColor,
                      space: 15,
                      text: 'Resend Verification Email',
                      child: const Icon(Icons.email, color: Colors.white),
                    ),
                    if (!_isResendLinkAvailable) SizedBox(height: 16.h),
                    if (!_isResendLinkAvailable)
                      Text(
                        'You can resend the verification email in $_remainingSeconds seconds.',
                        style: TextStyle(fontSize: 17.sp, color: Colors.black),
                      ),
                    if (!_isResendLinkAvailable) SizedBox(height: 16.h),
                    if (!_isResendLinkAvailable)
                      Text(
                        'Verification email sent to ${widget.user.email}',
                        style: TextStyle(fontSize: 14.sp, color: Colors.black),
                      ),
                    20.verticalSpace,
                    PrimaryButton(
                      onTap: () =>
                          Navigation.navigateReplace(Navigation.loginScreen),
                      width: 300.w,
                      text: 'Proceed to Login',
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const Image(image: AppImages.bottomWaves)
          ],
        ),
      ),
    );
  }

  Future<void> _sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
    showToast('Verification email sent');
  }

  void _startResendTimer() {
    const resendDelay = Duration(seconds: 60);

    _resendTimer = Timer.periodic(resendDelay, (timer) {
      setState(() {
        _isResendLinkAvailable = true;
        _remainingSeconds = 60;
      });
      _resendTimer?.cancel();
      _countdownTimer?.cancel();
    });

    setState(() {
      _isResendLinkAvailable = false;
      _remainingSeconds = 60;
    });

    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });
      if (_remainingSeconds == 0) {
        _countdownTimer?.cancel();
      }
    });
    // }
  }
}
