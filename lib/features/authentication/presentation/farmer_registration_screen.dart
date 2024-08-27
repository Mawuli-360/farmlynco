// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:farmlynco/core/services/messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/authentication/presentation/email_verification_screen.dart';
import 'package:farmlynco/features/authentication/presentation/widgets/text_with_button.dart';
import 'package:farmlynco/features/authentication/presentation/widgets/wave_background_images.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/app_form_field.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:farmlynco/util/loading_overlay.dart';
import 'package:farmlynco/util/show_exit_dialog.dart';
import 'package:farmlynco/util/show_toast.dart';

class FarmRegistrationScreen extends ConsumerWidget {
  const FarmRegistrationScreen({
    super.key,
    // required this.formData,
  });

  // final StoreSetupFormData formData;

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
  const _RegistrationSection(
      // this.formData,
      );

  // final StoreSetupFormData formData;

  @override
  ConsumerState<_RegistrationSection> createState() =>
      _RegistrationSectionState();
}

class _RegistrationSectionState extends ConsumerState<_RegistrationSection> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController storeDescriptionController =
  //     TextEditingController();
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

  void signUpFarmer() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final storeName = storeNameController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final password = passwordController.text.trim();
    // final storeDescrip = storeDescriptionController.text;
    final firestore = ref.watch(firebaseFirestoreProvider);
    final auth = ref.watch(firebaseAuthProvider);

    if (fullName.isEmpty ||
        email.isEmpty ||
        storeName.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        // storeDescrip.isEmpty ||
        _imageFile == null) {
      showToast("Please fill all fields");
      return;
    }

    loadingOverlay.show(context);

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('farmers_profile');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(_imageFile!);
      String imageUrl = await referenceImageToUpload.getDownloadURL();

      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      final userRecord = {
        'uid': user!.uid,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': "Farmer",
        'storeName': storeName,
        'imageUrl': imageUrl,
        'isApproved': false,
        // 'storeDetails': {
        //   'identityNumber': widget.formData.identityNumber,
        //   'identityType': widget.formData.identityType,
        //   'description': widget.formData.storeDescription,
        //   'farmLocation': widget.formData.storeLocation,
        //   'productCategory': widget.formData.selectedCategories
        // }
      };

      await firestore.collection('users').doc(user.uid).set(userRecord);

      await user.sendEmailVerification();

      final currentUser = auth.currentUser;

      showToast("user created successfully, please verify your email.");
      Navigation.navigateReplacement(
          EmailVerificationScreen(currentUser!, auth));

      loadingOverlay.hide();
      await MessagingService().subscribeToTopic('newUserSignups');

      for (var controller in [
        fullNameController,
        emailController,
        storeNameController,
        phoneNumberController,
        passwordController,
        // storeDescriptionController
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
      storeNameController,
      phoneNumberController,
      passwordController,
      // storeDescriptionController
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                60.verticalSpace,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Farmer\nRegistration",
                    style: TextStyle(fontSize: 32.sp),
                  ),
                ),
                25.verticalSpace,
                AppFormField(
                  prefixIcon: Icons.person_outlined,
                  labelText: 'Fullname',
                  hintText: 'kofi',
                  inputType: TextInputType.name,
                  onChanged: (value) => fullNameController.text = value,
                  controller: fullNameController,
                ),
                20.verticalSpace,
                AppFormField(
                  prefixIcon: Icons.mail_outline,
                  labelText: 'Email',
                  hintText: 'zigah@gmail.com',
                  inputType: TextInputType.emailAddress,
                  onChanged: (value) => emailController.text = value,
                  controller: emailController,
                ),
                20.verticalSpace,
                AppFormField(
                  prefixIcon: Icons.store_outlined,
                  labelText: 'Store name',
                  hintText: 'musa store',
                  onChanged: (value) => storeNameController.text = value,
                  controller: storeNameController,
                ),
                20.verticalSpace,
                AppFormField(
                  prefixIcon: Icons.phone_outlined,
                  labelText: 'Phone number',
                  hintText: '054********',
                  inputType: TextInputType.number,
                  onChanged: (value) => phoneNumberController.text = value,
                  controller: phoneNumberController,
                ),
                20.verticalSpace,
                AppFormField(
                  prefixIcon: Icons.key_outlined,
                  labelText: 'Password',
                  hintText: '****',
                  isPassword: true,
                  onChanged: (value) => passwordController.text = value,
                  controller: passwordController,
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
                                    color: Colors.white,
                                    shape: BoxShape.circle),
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
                    signUpFarmer();
                  },
                  text: "Sign Up",
                  fontSize: 18,
                  textColor: Colors.white,
                ),
                10.verticalSpace,
                TextWithButton(
                  text: 'Already have an account?',
                  buttonText: 'Sign in',
                  onPressed: () =>
                      Navigation.navigateTo(Navigation.loginScreen),
                ),
                40.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
