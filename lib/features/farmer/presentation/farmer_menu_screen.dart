import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/communication/chat/chat_home_screen.dart';
import 'package:farmlynco/main.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/user_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/menu_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view.dart';

class FarmerMenuScreen extends ConsumerWidget {
  const FarmerMenuScreen({
    super.key,
    required this.controller,
  });

  final ZoomDrawerController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailsProvider);
    return Scaffold(
      backgroundColor: AppColors.headerTitleColor,
      body: Container(
        width: double.infinity,
        color: AppColors.headerTitleColor,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              75.verticalSpace,
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.black,
                        leading: IconButton(
                            onPressed: () => Navigation.pop(),
                            icon: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Colors.white,
                              size: 22.h,
                            )),
                      ),
                      extendBody: true,
                      extendBodyBehindAppBar: true,
                      body: PhotoView(
                        imageProvider: CachedNetworkImageProvider(user
                                ?.imageUrl ??
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1200px-User-avatar.svg.png"),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ));
                },
                child: Stack(
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.h,
                      margin: EdgeInsets.only(left: 15.h),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(162, 255, 255, 255)),
                    ),
                    Positioned(
                      left: 5.h,
                      top: 5.h,
                      child: Container(
                        height: 90.h,
                        width: 90.h,
                        margin: EdgeInsets.only(left: 15.h),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(user
                                      ?.imageUrl ??
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1200px-User-avatar.svg.png"),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  15.horizontalSpace,
                  user != null
                      ? Text(
                          user.name,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        )
                      : const CustomText(
                          body: "User",
                          color: AppColors.white,
                        )
                ],
              ),
              50.verticalSpace,
              MenuTile(
                icon: Icons.person,
                menu: "Edit Profile",
                onTap: () {
                  drawerController.close?.call()?.then(
                        (value) => Navigation.openEditProfileScreen(),
                      );
                },
              ),
              15.verticalSpace,
              MenuTile(
                icon: Icons.medical_information_outlined,
                menu: "Crop Doctor",
                onTap: () {
                  drawerController.close?.call()?.then(
                        (value) => Navigation.openFarmerCropDoctor(),
                      );
                },
              ),
              15.verticalSpace,
              MenuTile(
                icon: Iconsax.message,
                menu: "Chat Bot",
                onTap: () {
                  drawerController.close?.call()?.then(
                        (value) => Navigation.openFarmerChatScreen(),
                      );
                },
              ),
              15.verticalSpace,
              MenuTile(
                icon: Iconsax.message,
                menu: "Chat Room",
                onTap: () {
                  drawerController.close?.call()?.then(
                        (value) =>
                            Navigation.navigatePush(const ChatHomeScreen()),
                      );
                },
              ),
              15.verticalSpace,
              MenuTile(
                icon: Iconsax.headphone,
                menu: "Help Center",
                onTap: () {
                  drawerController.close?.call()?.then(
                        (value) => Navigation.openHelpCenterScreen(),
                      );
                },
              ),
              15.verticalSpace,
              MenuTile(
                icon: Iconsax.info_circle,
                menu: "About Us",
                onTap: () {
                  drawerController.close?.call()?.then(
                        (value) => Navigation.openAboutUsScreen(),
                      );
                },
              ),
              50.verticalSpace,
              MenuTile(
                icon: Iconsax.logout,
                menu: "Logout",
                color: const Color.fromARGB(0, 165, 104, 104),
                onTap: () {
                  ref.read(authRepositoryProvider).signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
