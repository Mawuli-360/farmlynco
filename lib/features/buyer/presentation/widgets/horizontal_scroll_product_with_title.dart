import 'package:farmlynco/features/buyer/application/provider/products_provider.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/header_title.dart';
import 'package:farmlynco/shared/common_widgets/product_card.dart';
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
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(right: 10.r),
                      child: ProductCard(
                        product: data[index],
                      ),
                    ),
                  );
                },
                error: (error, st) => Text(error.toString()),
                loading: () => const CircularProgressIndicator())),
      ],
    );
  }
}
