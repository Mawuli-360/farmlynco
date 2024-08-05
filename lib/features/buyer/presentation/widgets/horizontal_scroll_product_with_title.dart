import 'package:farmlynco/features/buyer/application/provider/favorite_provider.dart';
import 'package:farmlynco/features/buyer/application/provider/products_provider.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/header_title.dart';
import 'package:farmlynco/shared/common_widgets/product_card.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalScrollProductWithTitle extends ConsumerWidget {
  const HorizontalScrollProductWithTitle({
    super.key,
    this.fontColor,
    this.fontSize,
  });

  final Color? fontColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productList = ref.watch(fetchSomeProductProvider);
    final bookmarkedItems = ref.watch(favoriteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTitle(
          title: "Products",
          fontColor: fontColor,
          fontSize: fontSize,
          onPressed: () => Navigation.openProductsScreen(),
        ),
        SizedBox(
            height: 230.h,
            child: productList.when(
                data: (data) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 15.r),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final isBookmarked = bookmarkedItems.any(
                            (item) => item.productId == data[index].productId);
                        return Padding(
                          padding: EdgeInsets.only(right: 10.r),
                          child: ProductCard(
                            product: data[index],
                            isBookmarked: isBookmarked,
                            onPressed: () {
                              ref
                                  .read(favoriteProvider.notifier)
                                  .toggleBookmark(data[index]);
                              isBookmarked
                                  ? showToast(
                                      "${data[index].name} remove from favorite 💓")
                                  : showToast(
                                      "${data[index].name} added to favorite 💓");
                            },
                          ),
                        );
                      });
                },
                error: (error, st) => Text(error.toString()),
                loading: () => const Center(
                      child: CustomLoadingScale(),
                    ))),
      ],
    );
  }
}
