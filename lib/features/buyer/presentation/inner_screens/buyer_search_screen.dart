import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/application/provider/favorite_provider.dart';
import 'package:farmlynco/features/buyer/application/provider/search_provider.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/product_card.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

class BuyerSearchScreen extends ConsumerStatefulWidget {
  const BuyerSearchScreen({super.key});

  @override
  ConsumerState<BuyerSearchScreen> createState() => _BuyerSearchScreenState();
}

class _BuyerSearchScreenState extends ConsumerState<BuyerSearchScreen> {
  String query = "";

  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResult = ref.watch(searchProductsProvider(query));
    final bookmarkedItems = ref.watch(favoriteProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton.filledTonal(
            color: Colors.white,
            padding: EdgeInsets.zero,
            style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(Color.fromARGB(255, 233, 233, 233))),
            onPressed: () => Navigation.pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 25.h,
              color: AppColors.green,
            )),
        title: SizedBox(
          width: 320.w,
          child: TextFormField(
            cursorColor: AppColors.green,
            controller: controller,
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
            decoration: InputDecoration(
                fillColor: const Color.fromARGB(34, 158, 158, 158),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 9.h, horizontal: 10.h),
                filled: true,
                focusedBorder: InputBorder.none,
                hintText: "Search for products....",
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.clear();
                        query = "";
                      });
                    },
                    icon: const Icon(Icons.close)),
                border: InputBorder.none),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: query.isEmpty
          ? SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/search_anim.json",
                    height: 230.h,
                    // width: 300.h,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: const CustomText(
                      body: "Start typing to search for products or vendors",
                      fontSize: 17,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  70.verticalSpace,
                ],
              ),
            )
          : SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 15.h),
                      child: CustomText(
                          body: '${searchResult.length} products found',
                          fontSize: 18),
                    ),
                    20.verticalSpace,
                    searchResult.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(top: 130.h),
                            child: Center(
                              child: Lottie.asset(
                                "assets/animations/empty_bookmark.json",
                                height: 230.h,
                                // width: 300.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : AnimationLimiter(
                            child: GridView.builder(
                              padding: EdgeInsets.only(
                                  bottom: 30.h, left: 8.h, right: 8.h),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 20.h,
                                childAspectRatio: 0.78.h,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.h
                              ),
                              itemBuilder: (_, index) {
                                final product = searchResult[index];
                                final isBookmarked = bookmarkedItems.any(
                                    (item) =>
                                        item.productId == product.productId);
                                return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    columnCount: 2,
                                    duration: const Duration(milliseconds: 700),
                                    child: ScaleAnimation(
                                      child: FadeInAnimation(
                                        child: ProductCard(
                                          product: searchResult[index],
                                          isBookmarked: isBookmarked,
                                          onPressed: () {
                                            ref
                                                .read(favoriteProvider.notifier)
                                                .toggleBookmark(
                                                    searchResult[index]);
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
                              itemCount: searchResult.length,
                              shrinkWrap: true,
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
