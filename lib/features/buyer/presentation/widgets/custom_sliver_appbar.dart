import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.appBgColor,
      expandedHeight: 153.h,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Column(
          children: [
            SizedBox(
              height: 170.h,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(183, 136, 219, 193),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.r),
                      bottomRight: Radius.circular(100.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    50.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 12.h),
                      child: const CustomText(
                        body: "Good afternoon, Mawuli",
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 26, 98, 86),
                      ),
                    ),
                    4.verticalSpace,
                    const CustomText(
                      body:
                          "Browse through farmlynco marketplace with excitement",
                      fontSize: 15,
                      textAlign: TextAlign.center,
                      color: Color.fromARGB(153, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(20.h),
        child: Container(
          color: AppColors.white,
          height: 50.h,
          width: double.infinity,
          child: const _SearchProductForm(),
        ),
      ),
    );
  }
}

class _SearchProductForm extends StatelessWidget {
  const _SearchProductForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: const Color.fromARGB(110, 88, 91, 89)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(37, 0, 0, 0),
              spreadRadius: 0.2.r,
              blurRadius: 3.r,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => Navigation.openSearchScreen(),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
                hintText: "Search for products",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
