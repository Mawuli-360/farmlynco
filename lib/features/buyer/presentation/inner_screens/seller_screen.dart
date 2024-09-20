import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/buyer/application/provider/favorite_provider.dart';
import 'package:farmlynco/features/buyer/application/provider/products_provider.dart';
import 'package:farmlynco/features/farmer/domain/farmer_user.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/product_card.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';

class SellerScreen extends ConsumerWidget {
  const SellerScreen(this.user, {super.key});

  final FarmerUser user;

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
              _SellerBody(user),
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
                          image: AppImages.ricehead)),
                ),
              ),
              _SellerInfoCard(user),
            ],
          ),
        ),
      ),
    );
  }
}

class _SellerBody extends ConsumerWidget {
  const _SellerBody(this.user);

  final FarmerUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productList = ref.watch(fetchProductForBuyersProvider(user.uid));
    final bookmarkedItems = ref.watch(favoriteProvider);

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
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.h),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(57, 95, 180, 249),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: const CustomText(
                          body:
                              'Farm trader focused on sourcing high-quality produce and building strong relationships for a fair and efficient farm-to-table supply chain.',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    60.verticalSpace,
                    CustomText(
                      body: "Products",
                      fontSize: 18,
                      left: 10.h,
                      fontWeight: FontWeight.w500,
                      color: AppColors.headerTitleColor,
                    ),
                    18.verticalSpace,
                    productList.when(
                        data: (data) {
                          return data.isEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      20.verticalSpace,
                                      Lottie.asset(
                                          "assets/animations/no_product.json",
                                          height: 100.h),
                                      10.verticalSpace,
                                      const CustomText(body: "No product found")
                                    ],
                                  ),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 20.h,
                                    childAspectRatio: 0.88.h,
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (_, index) {
                                    final product = data[index];
                                    final isBookmarked = bookmarkedItems.any(
                                        (item) =>
                                            item.productId ==
                                            product.productId);
                                    return AnimationConfiguration.staggeredGrid(
                                        position: index,
                                        columnCount: 2,
                                        duration:
                                            const Duration(milliseconds: 700),
                                        child: ScaleAnimation(
                                          child: FadeInAnimation(
                                            child: ProductCard(
                                              product: data[index],
                                              isBookmarked: isBookmarked,
                                              onPressed: () {
                                                ref
                                                    .read(favoriteProvider
                                                        .notifier)
                                                    .toggleBookmark(
                                                        data[index]);
                                                isBookmarked
                                                    ? showToast(
                                                        "Product:${product.name} remove from bookmark")
                                                    : showToast(
                                                        "Product:${product.name} added to bookmark");
                                              },
                                            ),
                                          ),
                                        ));
                                  },
                                  itemCount: data.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                );
                        },
                        error: (error, st) => Text(error.toString()),
                        loading: () =>
                            const Center(child: CustomLoadingScale())),
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
  const _SellerInfoCard(this.user);

  final FarmerUser user;

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
                    CustomText(body: user.email, fontSize: 15),
                  ],
                ),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.call, color: AppColors.green),
                    10.horizontalSpace,
                    CustomText(body: user.phoneNumber, fontSize: 15),
                  ],
                ),
                25.verticalSpace,
              ],
            ),
          ),
          Positioned(
            left: 0.5.sw - 70.h,
            top: -60.h,
            child: GestureDetector(
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
                        ),
                      ),
                    ),
                    extendBody: true,
                    extendBodyBehindAppBar: true,
                    body: PhotoView(
                      imageProvider: CachedNetworkImageProvider(user.imageUrl),
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
                  Container(
                    height: 100.h,
                    width: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          user.imageUrl,
                        ),
                      ),
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
          ),
        ],
      ),
    );
  }
}
