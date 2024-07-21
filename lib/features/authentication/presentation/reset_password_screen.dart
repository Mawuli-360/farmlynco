
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/authentication/presentation/widgets/wave_background_images.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/app_form_field.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:farmlynco/util/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final LoadingOverlay loadingOverlay = LoadingOverlay();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigation.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primaryColor,
              size: 25.h,
            )),
      ),
      body: Container(
          color: AppColors.appBgColor,
          width: 1.sw,
          height: 1.sh,
          child: Stack(children: [
            const TopBackgroundImage(),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      200.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Reset\nPassword",
                          style: TextStyle(fontSize: 35.sp),
                        ),
                      ),
                      30.verticalSpace,
                      Text(
                        "Please enter your registered email address, so we will send link to your email to reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      40.verticalSpace,
                      AppFormField(
                        prefixIcon: Icons.mail_outline,
                        labelText: 'Email',
                        hintText: 'zigah@gmail.com',
                        inputType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (value) => emailController.text = value,
                      ),
                      50.verticalSpace,
                      ref.watch(isResetPasswordLoading)
                          ? SizedBox(
                              height: 20.h,
                              width: 50.w,
                              child: const LoadingIndicator(
                                indicatorType: Indicator.lineScale,
                                colors: [
                                  Colors.blue,
                                  AppColors.headerTitleColor
                                ],
                              ),
                            )
                          : PrimaryButton(
                              onTap: () {
                                ref.read(authRepositoryProvider).resetPassword(
                                    email: emailController.text.trim());
                              },
                              fontSize: 18,
                              text: "Reset Password",
                              textColor: Colors.white,
                            ),
                      10.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            const BottomBackgroundImage()
          ])),
    );
  }
}
