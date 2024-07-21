import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/horizontal_scroll_product_with_title.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellerScreen extends ConsumerWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Seller"),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 1.sh,
          child: Stack(
            children: [
              const _SellerBody(),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 0.22.sh,
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Color.fromARGB(90, 0, 0, 0), BlendMode.darken),
                          fit: BoxFit.cover,
                          image: AppImages.sellerBg)),
                ),
              ),
              const _SellerInfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SellerBody extends StatelessWidget {
  const _SellerBody();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 0.67.sh,
      child: Container(
        width: double.infinity,
        height: 0.67.sh,
        color: Colors.transparent,
        child: Column(
          children: [
            100.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 10.h),
                      child:
                          const CustomText(body: "About Trader", fontSize: 18),
                    ),
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.h),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(57, 95, 180, 249),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: const CustomText(
                          body:
                              'Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame ',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.h),
                      child: PrimaryButton(
                        onTap: () => Navigation.openViewStoreScreen(),
                        text: "View store",
                        color: Colors.transparent,
                        useStadiumBorder: false,
                        borderColor: AppColors.green,
                        textColor: AppColors.primaryColor,
                        childAtStart: false,
                        space: 18,
                        height: 45.h,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    const HorizontalScrollProductWithTitle(
                      fontSize: 18,
                      fontColor: Color.fromARGB(183, 0, 0, 0),
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellerInfoCard extends StatelessWidget {
  const _SellerInfoCard();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 90.h,
      left: 0.04.sw,
      right: 0.04.sw,
      height: 0.20.sh,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(89, 158, 158, 158),
                  spreadRadius: 1.h,
                  blurRadius: 2.h,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mail, color: AppColors.green),
                    10.horizontalSpace,
                    const CustomText(
                        body: "zigahmawuli@gmail.com", fontSize: 15),
                  ],
                ),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.call, color: AppColors.green),
                    10.horizontalSpace,
                    const CustomText(body: "0545786643", fontSize: 15),
                  ],
                ),
                25.verticalSpace,
              ],
            ),
          ),
          Positioned(
            left: 0.5.sw - 70.h,
            top: -60.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 120.h,
                  width: 120.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  // left: 0.5.sw - 100.h,
                  child: Container(
                    height: 100.h,
                    width: 100.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                "https://www.un.org/africarenewal/sites/www.un.org.africarenewal/files/styles/ar_main_story_big_picture/public/00189603.jpg?itok=AWPQ_xcd"))),
                  ),
                ),
                Positioned(
                  bottom: 5.h,
                  right: 15.h,
                  child: Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 26.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
