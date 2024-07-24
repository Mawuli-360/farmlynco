import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/application/provider/products_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  // final List<String> choices = ["All", "Vegetables", "Grains", "Fruits"];
  final bool isChoiceSelected = false;
  @override
  Widget build(BuildContext context) {
    final allProduct = ref.watch(fetchAllProductProvider);
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
              // 20.verticalSpace,
              // SizedBox(
              //   height: 44.h,
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     padding: EdgeInsets.only(left: 15.h, right: 15.h),
              //     separatorBuilder: (context, index) => 10.horizontalSpace,
              //     itemCount: choices.length,
              //     itemBuilder: (context, index) => ChoiceChip(
              //         labelStyle: const TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.bold),
              //         color: WidgetStateProperty.all(
              //             const Color.fromARGB(152, 224, 242, 241)),
              //         shape: const StadiumBorder(
              //             side: BorderSide(color: AppColors.green)),
              //         showCheckmark: true,
              //         label: CustomText(
              //           body: choices[index],
              //           fontSize: 14,
              //         ),
              //         selected: true),
              //   ),
              // ),

              20.verticalSpace,
              allProduct.when(
                  data: (data) {
                    return GridView.builder(
                      padding:
                          EdgeInsets.only(bottom: 30.h, left: 8.h, right: 8.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20.h,
                        childAspectRatio: 0.85.h,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (_, index) => ProductCard(
                        product: data[index],
                      ),
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
