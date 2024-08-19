import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/user_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSliverAppBar extends ConsumerWidget {
  const CustomSliverAppBar({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good morning";
    } else if (hour < 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailsProvider);
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
                      child: CustomText(
                        body:
                            "${_getGreeting()}, ${user?.name.split(' ')[0] ?? "User"}",
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 26, 98, 86),
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

// The _SearchProductForm class remains unchanged
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
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 12.h),
                prefixIcon: const Icon(
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
