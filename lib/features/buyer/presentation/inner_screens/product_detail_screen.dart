import 'package:farmlynco/features/buyer/presentation/inner_screens/view_store_detail_screen.dart';
import 'package:farmlynco/features/communication/chat/chat_page.dart';
import 'package:farmlynco/features/communication/chat/chat_service.dart';
import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmlynco/util/loading_overlay.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  final bool isViewStore;
  final ProductModel product;

  const ProductDetailScreen(
      {super.key, required this.isViewStore, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

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
            GestureDetector(
              onTap: () async {
               
               final LoadingOverlay loadingOverlay = LoadingOverlay();

                loadingOverlay.show(context);

                try {
                  final chatService = ChatService();
                  final chatRoomID =
                      await chatService.initiateChatWithProductOwner(
                          widget.product.productOwner);

                 loadingOverlay.hide();

                  // Use a microtask to ensure the overlay is removed before navigation
                  await Future.microtask(() => Navigation.navigatePush(
                        ChatPage(
                          chatRoomID: chatRoomID,
                          receiverName: widget.product.productOwner,
                        ),
                      ));
                } catch (e) {
                 loadingOverlay.hide();
                  showToast("Failed to initialize chat. Please try again.");
                }
              },
              child: Container(
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
                      body: "Chat",
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    10.horizontalSpace,
                    Icon(
                      Iconsax.message,
                      color: AppColors.primaryColor,
                      size: 30.h,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _makePhoneCall(widget.product.userPhoneNumber);
              },
              child: Container(
                width: 180.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(118, 25, 163, 140),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20.r)),
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
                              widget.product.productImage,
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
                              body: widget.product.name,
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
                                  body: "In stock", fontSize: 14),
                            )
                          ],
                        ),
                        18.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  body: widget.product.storeName,
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
                              body: "GHC ${widget.product.price}.00",
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        6.verticalSpace,
                        10.verticalSpace,
                        Container(
                          padding: EdgeInsets.all(8.r),
                          child: CustomText(
                            body: widget.product.description,
                            fontSize: 14,
                          ),
                        ),
                        18.verticalSpace,
                        if (widget.isViewStore == true)
                          PrimaryButton(
                            onTap: () => Navigation.navigatePush(
                                ViewStoreDetailScreen(widget.product)),
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
                        20.verticalSpace,
                        const CustomText(
                          body: "Trader Info",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.headerTitleColor,
                        ),
                        10.verticalSpace,
                        _SellerInfoCard(widget.product),
                        20.verticalSpace
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
