import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/application/provider/favorite_provider.dart';
import 'package:farmlynco/features/buyer/application/provider/search_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/product_card.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final productList = ref.watch(fetchProductsProvider);
    final bookmarkedItems = ref.watch(favoriteProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Products"),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              productList.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return SizedBox(
                        width: double.infinity,
                        height: 0.7.sh,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/animations/no_product.json",
                              height: 150.h,
                              // width: 300.h,
                              fit: BoxFit.cover,
                            ),
                            20.verticalSpace,
                            const CustomText(body: "No products found")
                          ],
                        ),
                      );
                    }

                    return AnimationLimiter(
                      child: GridView.builder(
                        padding: EdgeInsets.only(
                            bottom: 30.h, left: 8.h, right: 8.h),
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
                      ),
                    );
                  },
                  error: (error, st) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator())
            ],
          ),
        ),
      )),
    );
  }
}
