import 'package:carousel_slider/carousel_slider.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/helper/image_helper.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsCarousel extends ConsumerStatefulWidget {
  const NewsCarousel({
    super.key,
  });

  @override
  ConsumerState<NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends ConsumerState<NewsCarousel>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 0;
  late CarouselController carouselController;

  @override
  void initState() {
    carouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigation.openNewsScreen(),
      child: SizedBox(
        height: 180.h,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 160.h,
              child: CarouselSlider(
                carouselController: carouselController,
                items: List.generate(4, (index) {
                  return Builder(builder: (BuildContext context) {
                    return ImageViewHelper.show(
                        context: context,
                        url:
                            "https://www.ghanaiantimes.com.gh/wp-content/uploads/2022/08/Farmers-with-their-harvested-Cocoa.jpg",
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.h, right: 8.h, bottom: 10.h),
                            child: const SizedBox(
                              width: double.infinity,
                              child: CustomText(
                                body: "Welcome to agriculture",
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ));
                  });
                }),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: true,
                  viewportFraction: 0.75.h,
                  autoPlayAnimationDuration: const Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {
                      // _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Align(alignment: Alignment.bottomCenter, child: _buildIndicators()),
          ],
        ),
      ),
    );
  }

// custom indicators
  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          height: 8.h,
          width: _currentIndex == index ? 22.w : 10.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
        );
      }),
    );
  }
}
