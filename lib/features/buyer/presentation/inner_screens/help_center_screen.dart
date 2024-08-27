import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HelpCenterScreen extends ConsumerStatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  ConsumerState<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends ConsumerState<HelpCenterScreen> {
  final TextEditingController controller = TextEditingController();
  bool isSubmitting = false;

  Future<void> submitReport() async {
    if (controller.text.isEmpty) {
      showToast("Report field cannot be empty");
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Get the current user
      var user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch user info from 'users' collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          // Create a map of the report data
          Map<String, dynamic> reportData = {
            'message': controller.text,
            'userId': user.uid,
            'fullName': userData['fullName'] ?? 'Unknown',
            'email': userData['email'] ?? 'Unknown',
            'phone': userData['phoneNumber'] ?? 'Unknown',
            'role': userData['role'] ?? 'Unknown',
            'timestamp': FieldValue.serverTimestamp(),
          };

          // Add the report to Firestore
          await FirebaseFirestore.instance.collection('help').add(reportData);
          setState(() {
            isSubmitting = false;
          });
          showToast("Report submitted successfully");
          controller.clear();
        } else {
          setState(() {
            isSubmitting = false;
          });
          showToast("User information not found");
        }
      } else {
        setState(() {
          isSubmitting = false;
        });
        showToast("User not logged in");
      }
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });
      showToast("Error submitting report: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Help Center"),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                20.verticalSpace,
                Lottie.asset("assets/animations/help_center.json"),
                20.verticalSpace,
                const CustomText(
                  body:
                      "We are here to help you get the most out of your experience with our app. Let us know how we can assist with all of your questions and issues!",
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                20.verticalSpace,
                TextFormField(
                  controller: controller,
                  minLines: 5,
                  maxLines: 6,
                  cursorColor: AppColors.green,
                  decoration: const InputDecoration(
                    hintText: "Write a report to us...",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.green)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.green)),
                  ),
                ),
                40.verticalSpace,
                isSubmitting
                    ? const CustomLoadingScale()
                    : PrimaryButton(
                        onTap: submitReport,
                        text: "Submit report",
                        textColor: Colors.white,
                      ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      )),
    );
  }
}
