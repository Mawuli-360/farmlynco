
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/authentication/presentation/controller/auth_controller.dart';
import 'package:farmlynco/features/authentication/presentation/widgets/wave_background_images.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/app_form_field.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:farmlynco/util/show_exit_dialog.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: AppColors.appBgColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          TopBackgroundImage(),
          _LoginSection(),
        ],
      ),
    );
  }
}

class _LoginSection extends ConsumerStatefulWidget {
  const _LoginSection();

  @override
  ConsumerState<_LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends ConsumerState<_LoginSection> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = ref.watch(isPasswordSelected);
    final role = ref.watch(selectedRole);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => showExitDialog(didPop, context),
      child: SizedBox(
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
                    "Login",
                    style: TextStyle(fontSize: 50.sp),
                  ),
                ),
                10.verticalSpace,
                AppFormField(
                  prefixIcon: Icons.mail_outline,
                  labelText: 'Email',
                  hintText: 'zigah@gmail.com',
                  inputType: TextInputType.emailAddress,
                  onChanged: (value) => emailController.text = value,
                ),
                20.verticalSpace,
                AppFormField(
                  prefixIcon: Icons.key_outlined,
                  labelText: 'Password',
                  hintText: '****',
                  isPassword: isPassword,
                  suffixIcon: IconButton(
                      onPressed: () => ref
                          .read(isPasswordSelected.notifier)
                          .state = !isPassword,
                      icon: Icon(isPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined)),
                  onChanged: (value) => passwordController.text = value,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: "Farmer",
                          groupValue: role,
                          onChanged: (value) =>
                              ref.read(selectedRole.notifier).state = value!,
                        ),
                        const Text('Farmer'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "Buyer",
                          groupValue: role,
                          onChanged: (value) =>
                              ref.read(selectedRole.notifier).state = value!,
                        ),
                        const Text('Buyer'),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () =>
                          Navigation.navigateTo(Navigation.resetPasswordScreen),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontSize: 16.sp, color: AppColors.primaryColor),
                      )),
                ),
                15.verticalSpace,
                ref.watch(isLoginLoading)
                    ? const CustomLoadingScale()
                    : PrimaryButton(
                        onTap: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            showToast("please fill the fields");
                            return;
                          }

                          ref
                              .read(authRepositoryProvider)
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                        },
                        text: "Login",
                        textColor: Colors.white,
                        fontSize: 18,
                      ),
                10.verticalSpace,
                if (role == "Buyer") buildAltSignIn(ref, context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                    TextButton(
                        onPressed: () => Navigation.navigateTo(
                            Navigation.registrationScreen),
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all(EdgeInsets.zero)),
                        child: Text("Sign Up",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp)))
                  ],
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAltSignIn(WidgetRef ref, BuildContext context) {
    return Column(
      children: [
        _buildDividerWithText(),
        10.verticalSpace,
        PrimaryButton(
          onTap: () =>
              ref.read(authRepositoryProvider).signInWithGoogle(context),
          color: AppColors.white,
          borderColor: AppColors.primaryColor,
          text: "Sign in with Google",
          space: 15,
          fontSize: 15,
          childAtStart: true,
          child: AppImages.google,
        ),
        25.verticalSpace,
      ],
    );
  }

  Widget _buildDividerWithText() {
    return SizedBox(
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(
              endIndent: 10,
              color: Color.fromARGB(58, 158, 158, 158),
            ),
          ),
          Text(
            "Sign in with",
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
          ),
          const Expanded(
            child: Divider(
              indent: 10,
              color: Color.fromARGB(58, 158, 158, 158),
            ),
          ),
        ],
      ),
    );
  }
}
