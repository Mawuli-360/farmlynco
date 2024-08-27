import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/authentication/presentation/controller/auth_controller.dart';
import 'package:farmlynco/features/authentication/presentation/widgets/wave_background_images.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/data/authentication/auth_screen_data.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:farmlynco/util/show_exit_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistrationScreen extends ConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectIndex = ref.watch(selectedIndex);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => showExitDialog(didPop, context),
      child: Scaffold(
        backgroundColor: AppColors.appBgColor,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: AppImages.overlapCircle,
            ),
            const BottomBackgroundImage(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CustomText(body: "I am here to ....", fontSize: 20),
                  30.verticalSpace,
                  SizedBox(
                    height: 218.h,
                    child: Center(
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: AuthScreenData.registrationOptions.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (context, index) =>
                              18.verticalSpace,
                          itemBuilder: (context, index) {
                            return _RegistrationOption(
                                title: AuthScreenData
                                    .registrationOptions[index].title,
                                image: AuthScreenData
                                    .registrationOptions[index].image,
                                isSelected: index == selectIndex,
                                onTap: () {
                                  ref.read(selectedIndex.notifier).state =
                                      index;
                                });
                          }),
                    ),
                  ),
                  45.verticalSpace,
                  PrimaryButton(
                    onTap: () {
                      final index = selectIndex;

                      if (index == 0) {
                        // Navigation.navigatePush(const StoreSetup());
                        Navigation.navigateTo(
                            Navigation.farmerRegistrationScreen);
                      } else {
                        Navigation.navigateTo(
                            Navigation.buyerRegistrationScreen);
                      }
                    },
                    text: "Create an account",
                    fontSize: 18,
                    textColor: Colors.white,
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.black, fontSize: 18.sp),
                      ),
                      TextButton(
                          onPressed: () =>
                              Navigation.navigateTo(Navigation.loginScreen),
                          style: ButtonStyle(
                              padding:
                                  WidgetStateProperty.all(EdgeInsets.zero)),
                          child: Text("Sign in",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 18.sp)))
                    ],
                  ),
                  140.verticalSpace
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RegistrationOption extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final AssetImage image;
  final bool isSelected;

  const _RegistrationOption(
      {required this.onTap,
      required this.title,
      required this.image,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            color: isSelected
                ? const Color.fromARGB(83, 136, 219, 193)
                : AppColors.white,
            borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          children: [
            15.horizontalSpace,
            Image(
              height: 80.h,
              width: 80.h,
              image: image,
              fit: BoxFit.fill,
            ),
            10.horizontalSpace,
            Text(
              title,
              style: TextStyle(fontSize: 18.sp),
            ),
            Expanded(
              child: Center(
                child: isSelected
                    ? Container(
                        height: 25.h,
                        width: 25.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.h,
                        ),
                      )
                    : Icon(
                        Icons.circle_outlined,
                        color: AppColors.primaryColor,
                        size: 28.h,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
