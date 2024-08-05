import 'package:farmlynco/features/farmer/domain/farmer_user.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellerCard extends StatelessWidget {
  const SellerCard({super.key, required this.user});

  final FarmerUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 174.w,
      margin: EdgeInsets.only(right: 15.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: const Color.fromARGB(70, 0, 0, 0),
                blurRadius: 2.h,
                spreadRadius: 0.2.r,
                offset: const Offset(0, 0)),
          ],
          image:  DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                  user.imageUrl))),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 8.h, bottom: 10.h, right: 8.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              color: const Color.fromARGB(131, 0, 0, 0),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.h),
              child:  CustomText(
                body: "Name: ${user.fullName}",
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
