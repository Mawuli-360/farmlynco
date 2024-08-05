import 'package:farmlynco/features/buyer/presentation/inner_screens/read_detail_screen.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' show parse;

class FarmerCard extends StatelessWidget {
  const FarmerCard({
    super.key,
    required this.image,
    required this.content,
  });

  final String image;
  final String content;

  @override
  Widget build(BuildContext context) {
    final document = parse(content);
    final paragraphs = document.getElementsByTagName('p');
    final String plainText = paragraphs.isNotEmpty
        ? paragraphs.map((element) => element.text).join(' ')
        : '';
        
    return GestureDetector(
      onTap: () => Navigation.navigatePush(ReadDetailScreen(
        image: image,
        content: content,
      )),
      child: Container(
        padding: EdgeInsets.all(5.h),
        margin: EdgeInsets.symmetric(horizontal: 10.h),
        width: 180.w,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color.fromARGB(99, 158, 158, 158)),
            borderRadius: BorderRadius.circular(10.h),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(19, 0, 0, 0),
                spreadRadius: 2.h,
                blurRadius: 15.h,
              )
            ]),
        child: Column(
          children: [
            Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.h),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(image))),
            ),
            Container(
              height: 110.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: CustomText(
                body: plainText,
                maxLines: 4,
                fontSize: 14,
                top: 8.h,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
