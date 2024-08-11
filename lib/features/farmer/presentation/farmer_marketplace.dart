import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_inner_screens/farm_edit_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_inner_screens/farmer_inner_screens_widgets.dart/responsive_gridview_item.dart';
import 'package:farmlynco/features/farmer/presentation/farmers_providers/fetch_product.dart';
import 'package:farmlynco/main.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/util/loading_overlay.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class FarmerMarketPlace extends ConsumerStatefulWidget {
  const FarmerMarketPlace({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FarmerMarketPlaceState();
}

class _FarmerMarketPlaceState extends ConsumerState<FarmerMarketPlace> {
  final LoadingOverlay loadingOverlay = LoadingOverlay();

  Future<void> deleteProduct(String productId) async {
    try {
      // Get the product document from Cloud Firestore
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      // Get the image download URL from the product document
      String imageUrl = productSnapshot.get('productImage');

      // Delete the product document from Cloud Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();

      // Delete the product image from Firebase Storage
      Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await imageRef.delete();
    } catch (e) {
      setState(() {
        showToast('Error deleting product: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final countProduct = ref.watch(productCountProvider);
    final fetchProduct = ref.watch(fetchFarmerProductProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: CustomAppBar(
          title: "Marketplace",
          leading: IconButton(
            onPressed: () => drawerController.toggle?.call(),
            icon: const Icon(
              Icons.menu,
              color: AppColors.headerTitleColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: AppColors.white,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                15.verticalSpace,
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 3.5.h),
                  height: 160.h,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Color.fromARGB(96, 0, 0, 0), BlendMode.darken),
                          fit: BoxFit.cover,
                          image: AppImages.oyingbo)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        body: 'Total product added',
                        fontSize: 22,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      8.verticalSpace,
                      CustomText(
                        body: countProduct.asData?.value.toString() ?? "0",
                        fontSize: 25,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                30.verticalSpace,
                fetchProduct.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "NO PRODUCTS",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: GridView.builder(
                          itemCount: data.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: screenWidth * 0.02,
                            childAspectRatio: screenWidth < 600 ? 0.95 : 0.6,
                          ),
                          itemBuilder: (context, index) {
                            return ResponsiveGridViewItem(
                                imageUrl: data[index].productImage,
                                name: data[index].name,
                                price: double.parse(data[index].price),
                                onEdit: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => FarmEditScreen(
                                            product: data[index]))),
                                onDelete: () =>
                                    deleteProduct(data[index].productId));
                          }),
                    );
                  },
                  loading: () => Center(
                      child: SizedBox(
                    height: 12.h,
                    width: 12.h,
                    child: const LoadingIndicator(
                      indicatorType: Indicator.ballClipRotateMultiple,
                    ),
                  )),
                  error: (error, stackTrace) => Expanded(
                    child: Center(
                      child: Text(error.toString()),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Align(
          widthFactor: 1.h,
          heightFactor: 4.h,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 187, 233, 233),
            elevation: 0,
            onPressed: () => Navigation.navigateTo(Navigation.addProductScreen),
            child: const Icon(
              Icons.add,
              color: AppColors.primaryColor,
            ),
          ),
        ));
  }
}
