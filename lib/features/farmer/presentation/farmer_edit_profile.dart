import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/app_form_field.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FarmerEditProfileScreen extends ConsumerStatefulWidget {
  const FarmerEditProfileScreen({super.key});

  @override
  _FarmerEditProfileScreenState createState() =>
      _FarmerEditProfileScreenState();
}

class _FarmerEditProfileScreenState
    extends ConsumerState<FarmerEditProfileScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadFarmerData();
  }

  Future<void> _loadFarmerData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final farmerData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _fullnameController.text = farmerData['fullName'] ?? '';
        _emailController.text = farmerData['email'] ?? '';
        _imageUrl = farmerData['imageUrl'];
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? imageUrl = _imageUrl;
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('farmers_profile')
            .child('${user.uid}.jpg');
        await ref.putFile(_imageFile!);
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fullName': _fullnameController.text,
        'email': _emailController.text,
        'imageUrl': imageUrl,
      });

      // Update email in Firebase Auth if changed
      if (user.email != _emailController.text) {
        await user.verifyBeforeUpdateEmail(_emailController.text);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Edit Profile"),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h),
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 0.8.sh,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 160.h,
                                  width: 160.h,
                                ),
                                Positioned(
                                  child: Container(
                                    height: 140.h,
                                    width: 140.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            215, 169, 169, 169),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: _imageFile != null
                                        ? Image.file(_imageFile!,
                                            fit: BoxFit.cover)
                                        : (_imageUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: _imageUrl!,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(Icons.person,
                                                size: 80)),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.h,
                                  right: 0.h,
                                  child: IconButton(
                                    onPressed: _pickImage,
                                    icon: Icon(
                                      Icons.edit,
                                      size: 25.sp,
                                      color: AppColors.green,
                                    ),
                                    color: const Color.fromARGB(
                                        255, 237, 242, 241),
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Color.fromARGB(255, 237, 242, 241),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      60.verticalSpace,
                      AppFormField(
                        prefixIcon: Icons.person_outline,
                        labelText: "Fullname",
                        hintText: "Enter your full name",
                        controller: _fullnameController,
                      ),
                      20.verticalSpace,
                      AppFormField(
                        prefixIcon: Icons.mail_outline,
                        labelText: "Email",
                        hintText: "Enter your email",
                        controller: _emailController,
                      ),
                      50.verticalSpace,
                      PrimaryButton(
                        onTap: _updateProfile,
                        text: "Save edit",
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
