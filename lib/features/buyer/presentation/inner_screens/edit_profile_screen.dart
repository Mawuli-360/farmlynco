import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/app_form_field.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                                  // left: 0.5.sw - 100.h,
                                  child: Container(
                                    height: 140.h,
                                    width: 140.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                215, 169, 169, 169),
                                            width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 0, 0, 0)
                                                .withOpacity(0.25),
                                            spreadRadius: 0,
                                            blurRadius: 4,
                                            offset: const Offset(0,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                                "https://www.un.org/africarenewal/sites/www.un.org.africarenewal/files/styles/ar_main_story_big_picture/public/00189603.jpg?itok=AWPQ_xcd"))),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.h,
                                  right: 0.h,
                                  child: IconButton(
                                    onPressed: () {},
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
                      const AppFormField(
                          prefixIcon: Icons.person_outline,
                          labelText: "Fullname",
                          hintText: "hintText"),
                      20.verticalSpace,
                      const AppFormField(
                          prefixIcon: Icons.mail_outline,
                          labelText: "Email",
                          hintText: "hintText"),
                      50.verticalSpace,
                      PrimaryButton(
                        onTap: () {},
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
