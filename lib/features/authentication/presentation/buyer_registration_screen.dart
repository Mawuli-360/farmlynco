import 'dart:io';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/authentication/presentation/email_verification_screen.dart';
import 'package:farmlynco/features/authentication/presentation/widgets/text_with_button.dart';
import 'package:farmlynco/features/authentication/presentation/widgets/wave_background_images.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/app_form_field.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:farmlynco/util/loading_overlay.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class BuyerRegistrationScreen extends ConsumerWidget {
  const BuyerRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColors.appBgColor,
        width: 1.sw,
        height: 1.sh,
        child: const Stack(
          children: [
            TopBackgroundImage(),
            _RegistrationSection(),
          ],
        ),
      ),
    );
  }
}

class _RegistrationSection extends ConsumerStatefulWidget {
  const _RegistrationSection();

  @override
  ConsumerState<_RegistrationSection> createState() =>
      _RegistrationSectionState();
}

class _RegistrationSectionState extends ConsumerState<_RegistrationSection> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _imageFile;
  final LoadingOverlay loadingOverlay = LoadingOverlay();
  Future<void> _pickImage(BuildContext context) async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
        ],
      ),
    );
    if (imageSource != null) {
      final imagePicker = ImagePicker();
      final file = await imagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() {
          _imageFile = File(file.path);
        });
      }
    }
  }

  void signUpBuyer() async {
    final fullName = fullNameController.text;
    final email = emailController.text.trim();
    final password = passwordController.text;
    final firestore = ref.watch(firebaseFirestoreProvider);
    final auth = ref.watch(firebaseAuthProvider);

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _imageFile == null) {
      showToast("Please fill all fields");

      return;
    }

    loadingOverlay.show(context);

    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      final userRecord = {
        'fullName': fullName,
        'email': email,
        'role': "Buyer",
      };

      await firestore.collection('users').doc(user!.uid).set(userRecord);

      // Send email verification
      await user.sendEmailVerification();
      final currentUser = auth.currentUser;

      showToast("user created successfully, please verify your email.");

      // Navigate to the email verification screen
      Navigation.navigateReplacement(
          EmailVerificationScreen(currentUser!, auth));
      ref.watch(isBuyerSigningUp.notifier).state = false;

      loadingOverlay.hide();

      for (var controller in [
        fullNameController,
        emailController,
        passwordController,
      ]) {
        controller.clear();
      }
    } catch (e) {
      showToast(e.toString());
      loadingOverlay.hide();
    }
  }

  @override
  void dispose() {
    for (var controller in [
      fullNameController,
      emailController,
      passwordController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              100.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Buyer\nRegistration",
                  style: TextStyle(fontSize: 32.sp),
                ),
              ),
              25.verticalSpace,
              AppFormField(
                prefixIcon: Icons.person_outline,
                labelText: 'Fullname',
                hintText: 'Kofi',
                inputType: TextInputType.name,
                controller: fullNameController,
                onChanged: (value) => fullNameController.text = value,
              ),
              20.verticalSpace,
              AppFormField(
                prefixIcon: Icons.mail_outline,
                labelText: 'Email',
                hintText: 'zigah@gmail.com',
                inputType: TextInputType.emailAddress,
                controller: emailController,
                onChanged: (value) => emailController.text = value,
              ),
              20.verticalSpace,
              AppFormField(
                prefixIcon: Icons.key_outlined,
                labelText: 'Password',
                hintText: '****',
                isPassword: true,
                controller: passwordController,
                onChanged: (value) => passwordController.text = value,
              ),
              20.verticalSpace,
              Text(
                "Upload Profile Picture",
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              5.verticalSpace,
              GestureDetector(
                  onTap: () => _pickImage(context),
                  child: _imageFile == null
                      ? Container(
                          width: 200.w,
                          height: 157,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 61, 170, 152),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              height: 80.h,
                              width: 80.h,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Center(
                                child: Icon(
                                  Icons.camera,
                                  size: 24.h,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            SizedBox(
                              width: 190.w,
                              height: 120.h,
                            ),
                            Positioned(
                              top: 1.h,
                              left: 1.h,
                              child: Container(
                                width: 190.w,
                                height: 120.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.fill),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _pickImage(context),
                              child: CircleAvatar(
                                radius: 20.h,
                                backgroundColor: AppColors.primaryColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
              25.verticalSpace,
              PrimaryButton(
                onTap: () {
                  signUpBuyer();
                },
                text: "Sign Up",
                textColor: Colors.white,
                fontSize: 18,
              ),
              30.verticalSpace,
              TextWithButton(
                text: 'Already have an account?',
                buttonText: 'Sign in',
                onPressed: () => Navigation.navigateTo(Navigation.loginScreen),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
