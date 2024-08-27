import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitingScreen extends ConsumerWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AppImages.waiting,
              height: 300.h,
            ),
            30.verticalSpace,
            const CustomText(
              body:
                  "Please you will be notified via email and telephone call when the verification process is done",
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            PrimaryButton(
              onTap: () async {
                // Call the signOut method from AuthRepository
                await ref.read(authRepositoryProvider).signOut(context);

                // Navigate to the login screen after logout
                Navigation.navigateReplace(Navigation.loginScreen);
              },
              width: 300.w,
              text: "Go Back",
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
