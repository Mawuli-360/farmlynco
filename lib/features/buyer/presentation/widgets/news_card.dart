// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:farmlynco/features/buyer/presentation/inner_screens/read_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:html/parser.dart' show parse;

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.image,
    required this.title,
    required this.content,
  });

  final String image;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final document = parse(content);
    final String plainText = parse(document.body!.text).documentElement!.text;
    return GestureDetector(
      onTap: () => Navigation.navigatePush(
          ReadDetailScreen(image: image, content: content)),
      child: Container(
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
                color: const Color.fromARGB(43, 0, 0, 0),
                spreadRadius: 0.2.r,
                blurRadius: 4.r,
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
                image: CachedNetworkImageProvider(image),
              ),
            ),
            8.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                10.verticalSpace,
                SizedBox(
                  width: 225.w,
                  child: CustomText(
                      body: title,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 225.w,
                  child: CustomText(
                      body: plainText,
                      color: AppColors.primaryColor,
                      maxLines: 3,
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: 14),
                ),
                // SizedBox(
                //   height: 28.h,
                //   width: 28.h,
                //   child: IconButton(
                //       onPressed: () {},
                //       padding: EdgeInsets.zero,
                //       iconSize: 25.h,
                //       icon: const Icon(Icons.bookmark_outline)),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
