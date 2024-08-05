import 'package:farmlynco/features/buyer/application/provider/favorite_provider.dart';
import 'package:farmlynco/features/buyer/application/provider/products_provider.dart';
import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/product_card.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ViewStoreDetailScreen extends ConsumerStatefulWidget {
  const ViewStoreDetailScreen(this.product, {super.key});

  final ProductModel product;
  @override
  ConsumerState<ViewStoreDetailScreen> createState() =>
      _ViewStoreDetailScreenState();
}

class _ViewStoreDetailScreenState extends ConsumerState<ViewStoreDetailScreen> {
  final List<String> choices = ["All", "Vegetables", "Grains", "Fruits"];
  final bool isChoiceSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _ViewStoreHeader(widget.product.profilePic),
            _ViewStoreContent(productModel: widget.product,choices: choices),
          ],
        ),
      ),
    );
  }
}

class _ViewStoreContent extends ConsumerWidget {
  const _ViewStoreContent({ required this.productModel, 
    required this.choices,
  });

  final List<String> choices;
  final ProductModel productModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productList = ref.watch(fetchProductForBuyersProvider(productModel.userId));
    final bookmarkedItems = ref.watch(favoriteProvider);

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CustomText(
                          body: "Daniel Stores",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.headerTitleColor,
                        ),
                        10.horizontalSpace,
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 25.h,
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(
                          5,
                          (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              )),
                    )
                  ],
                ),
                6.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.r),
                      child: Container(
                        color: const Color.fromARGB(39, 244, 67, 54),
                        padding: EdgeInsets.symmetric(vertical: 6.r),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.red,
                              size: 18.sp,
                            ),
                            4.horizontalSpace,
                            SizedBox(
                              width: 200.w,
                              child: Text("Borteyman, Greater Accra",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.r),
                      child: Container(
                        color: const Color.fromARGB(39, 76, 175, 79),
                        padding: EdgeInsets.symmetric(vertical: 6.r),
                        child: Row(
                          children: [
                            Icon(
                              Icons.alarm,
                              color: Colors.green,
                              size: 18.sp,
                            ),
                            6.horizontalSpace,
                            SizedBox(
                              width: 120.w,
                              child: Text("8am - 8pm 0nly",
                                  style: TextStyle(fontSize: 14.sp)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Container(
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
                20.verticalSpace,
                const CustomText(
                  body: "Products",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.headerTitleColor,
                ),
                18.verticalSpace,
                productList.when(
                    data: (data) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 20.h,
                          childAspectRatio: 0.85.h,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (_, index) {
                          final product = data[index];
                          final isBookmarked = bookmarkedItems.any(
                              (item) => item.productId == product.productId);
                          return AnimationConfiguration.staggeredGrid(
                              position: index,
                              columnCount: 2,
                              duration: const Duration(milliseconds: 700),
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: ProductCard(
                                    product: data[index],
                                    isBookmarked: isBookmarked,
                                    onPressed: () {
                                      ref
                                          .read(favoriteProvider.notifier)
                                          .toggleBookmark(data[index]);
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
                    loading: () => const CircularProgressIndicator()),

                38.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewStoreHeader extends StatelessWidget {
  const _ViewStoreHeader(this.image);

  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 286.h,
      child: Stack(
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
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/images/happycustomers.jpg")
                            // CachedNetworkImageProvider(
                            //   "https://www.thespruce.com/thmb/fghCcR0Sv_lrSIg1mVWS9U-b_ts=/4002x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-grow-watermelons-1403491-hero-2d1ce0752fed4ed599db3ba3b231f8b7.jpg",
                            // ),
                            )),
                  ),
                  Positioned(
                    bottom: -40.h,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 15.r,
                      ),
                      height: 90.h,
                      width: 90.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 5.h, color: Colors.white),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              image,
                            ),
                          )),
                    ),
                  )
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
                icon: Icon(
                  Icons.arrow_back,
                  size: 25.h,
                  color: AppColors.green,
                )),
          )
        ],
      ),
    );
  }
}
