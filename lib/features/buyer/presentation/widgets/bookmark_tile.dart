import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkTile extends StatelessWidget {
  const BookmarkTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110.h,
      margin: EdgeInsets.only(
        bottom: 15.h,
        left: 15.h,
        right: 15.h,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(37, 0, 0, 0),
              spreadRadius: 0.2.r,
              blurRadius: 3.r,
            ),
          ]),
      child: Row(
        children: [
          5.horizontalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image(
              height: 100.h,
              width: 110.h,
              fit: BoxFit.cover,
              image: const CachedNetworkImageProvider(
                  "https://www.thespruce.com/thmb/fghCcR0Sv_lrSIg1mVWS9U-b_ts=/4002x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-grow-watermelons-1403491-hero-2d1ce0752fed4ed599db3ba3b231f8b7.jpg"),
            ),
          ),
          8.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              10.verticalSpace,
              SizedBox(
                width: 225.w,
                child: const CustomText(
                    body: 'Musa store',
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              SizedBox(
                width: 225.w,
                child: const CustomText(
                    body:
                        '42 vendors found adadadadadasdadassdadadassfafdfsdsdfd',
                    color: AppColors.primaryColor,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    fontSize: 15),
              ),
              SizedBox(
                height: 28.h,
                width: 28.h,
                child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    iconSize: 25.h,
                    icon: const Icon(Icons.bookmark_outline)),
              )
            ],
          )
        ],
      ),
    );
  }
}
