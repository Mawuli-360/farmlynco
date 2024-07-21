import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/product_detail_screen.dart';
import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.onTap,
    required this.product,
  });

  final void Function()? onTap;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () => Navigation.navigatePush(ProductDetailScreen(
                isViewStore: true,
                product: product,
              )),
      child: SizedBox(
        height: 230.h,
        width: 180.w,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 4.h),
                width: 174.w,
                padding: EdgeInsets.symmetric(horizontal: 10.r),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(70, 0, 0, 0),
                          blurRadius: 2.h,
                          spreadRadius: 0.2.r,
                          offset: const Offset(0, 0)),
                      BoxShadow(
                          color: const Color.fromARGB(16, 0, 0, 0),
                          blurRadius: 1.h,
                          spreadRadius: 0.1.r,
                          offset: const Offset(-1, -1)),
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r))),
                height: 90.h,
                // width: 180.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    5.verticalSpace,
                    CustomText(
                      body: product.name,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      color: AppColors.primaryColor,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    CustomText(
                      body: product.description,
                      fontSize: 14,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    5.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 140.w,
                          child: CustomText(
                            body: "GHC ${product.price}.00",
                            fontSize: 15,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            maxLines: 1,
                            textOverflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 138.h,
                width: 174.w,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r)),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: product.productImage,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton.filledTonal(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(CircleBorder(
                                side: BorderSide(
                                    color: Colors.white, width: 2.h))),
                            backgroundColor: const WidgetStatePropertyAll(
                                Color.fromARGB(94, 255, 255, 255)),
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          )),
                    )
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
