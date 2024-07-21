
import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopPickCard extends StatelessWidget {
  const TopPickCard({
    super.key,
    required this.pageController,
    required this.pageOffset,
  });

  final PageController pageController;
  final double pageOffset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: PageView.builder(
          itemCount: 3,
          controller: pageController,
          itemBuilder: (context, i) {
            return parallaxCard(i);
          }),
    );
  }

  Widget parallaxCard(int i) {
    return GestureDetector(
      onTap: () => Navigation.openReadDetailScreen(),
      child: Transform.scale(
        scale: 0.98,
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(46, 0, 0, 0),
                          spreadRadius: 2.r,
                          blurRadius: 3.r)
                    ]),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      alignment: Alignment(-pageOffset.abs() + i, 0),
                      height: 280.h,
                      imageUrl:
                          "https://www.thespruce.com/thmb/fghCcR0Sv_lrSIg1mVWS9U-b_ts=/4002x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-grow-watermelons-1403491-hero-2d1ce0752fed4ed599db3ba3b231f8b7.jpg",
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10.h,
                bottom: 20.h,
                right: 10.h,
                child: Container(
                  padding: EdgeInsets.all(5.h),
                  margin: EdgeInsets.symmetric(horizontal: 3.h),
                  color: const Color.fromARGB(162, 255, 255, 255),
                  child: const CustomText(
                    body:
                        "Paintings is the most lucrative way of doing things and in agriculture it serves a really great work of supplying",
                    fontSize: 16,
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
