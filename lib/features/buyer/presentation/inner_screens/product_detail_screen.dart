import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/view_store_detail_screen.dart';
import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:farmlynco/core/constant/app_colors.dart';

class ProductDetailScreen extends StatelessWidget {
  final bool isViewStore;
  final ProductModel product;

  const ProductDetailScreen(
      {super.key, required this.isViewStore, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: Container(
        height: 50.h,
        color: const Color.fromARGB(0, 99, 14, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 180.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(118, 25, 163, 140),
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(20.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    body: "Whatsapp",
                    fontSize: 18,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  10.horizontalSpace,
                  AppImages.whatsapp
                ],
              ),
            ),
            Container(
              width: 180.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(118, 25, 163, 140),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call_outlined,
                    color: AppColors.primaryColor,
                    size: 30.h,
                  ),
                  10.horizontalSpace,
                  const CustomText(
                    body: "Call",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  10.horizontalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 250.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 270.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              product.productImage,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 10.h,
                  child: IconButton.filledTonal(
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigation.pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.green,
                      )),
                ),
                Positioned(
                  bottom: 5.h,
                  right: 5.h,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_outline,
                        color: Colors.white,
                        size: 35.h,
                      )),
                )
              ],
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        30.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              body: product.name,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.headerTitleColor,
                            ),
                            Container(
                              padding: EdgeInsets.all(5.r),
                              decoration: const ShapeDecoration(
                                  color: Color.fromARGB(21, 76, 175, 79),
                                  shape: StadiumBorder(
                                      side:
                                          BorderSide(color: AppColors.green))),
                              child: const CustomText(
                                  body: "Out of stock", fontSize: 14),
                            )
                          ],
                        ),
                        18.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CustomText(
                                  body: "Daniel store",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.headerTitleColor,
                                ),
                                10.horizontalSpace,
                                Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 22.h,
                                ),
                              ],
                            ),
                            CustomText(
                              body: "GHC ${product.price}.00",
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        6.verticalSpace,
                        10.verticalSpace,
                        Container(
                          padding: EdgeInsets.all(8.r),
                          child: const CustomText(
                            body:
                                'Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame Lorem ipsum dolor sit ame ',
                            fontSize: 14,
                          ),
                        ),
                        18.verticalSpace,
                        if (isViewStore == true)
                          PrimaryButton(
                            onTap: () => Navigation.navigatePush(
                                ViewStoreDetailScreen(product)),
                            text: "View store",
                            color: Colors.transparent,
                            useStadiumBorder: false,
                            borderColor: AppColors.green,
                            textColor: AppColors.primaryColor,
                            childAtStart: false,
                            space: 18,
                            child: const Icon(
                              Icons.arrow_forward,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        40.verticalSpace,
                        const CustomText(
                          body: "Trader Info",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.headerTitleColor,
                        ),
                        10.verticalSpace,
                        _SellerInfoCard(product),
                      ],
                    ),
                  ),
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
  const _SellerInfoCard(this.product);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          BoxShadow(
            color: const Color.fromARGB(38, 158, 158, 158),
            spreadRadius: 0.5.h,
            blurRadius: 1.h,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            height: 100.h,
            width: 100.h,
            margin: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      product.profilePic,
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mail, color: AppColors.green),
                  10.horizontalSpace,
                  CustomText(body: product.productOwner, fontSize: 12),
                ],
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.call, color: AppColors.green),
                  10.horizontalSpace,
                  CustomText(body: product.userPhoneNumber, fontSize: 12),
                ],
              ),
              25.verticalSpace,
            ],
          ),
        ],
      ),
    );
  }
}
