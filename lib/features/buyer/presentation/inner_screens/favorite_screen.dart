import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  final bool isFavouriteListEmpty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: isFavouriteListEmpty
            ? const _EmptyFavoriteContent()
            : const FavoriteContent(),
      ),
    );
  }
}

class FavoriteContent extends StatelessWidget {
  const FavoriteContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Padding(
          padding: EdgeInsets.only(left: 15.h),
          child: const CustomText(
            body: "Your Favourite Products",
            fontSize: 18,
            color: AppColors.primaryColor,
          ),
        ),
        20.verticalSpace,
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.only(bottom: 30.h, left: 8.h, right: 8.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 20.h,
              childAspectRatio: 0.83,
              crossAxisCount: 2,
            ),
            itemBuilder: (_, index) => Container(),
            itemCount: 10,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}

class _EmptyFavoriteContent extends StatelessWidget {
  const _EmptyFavoriteContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/favorite.json", height: 230.h),
            20.verticalSpace,
            const CustomText(
              body: "All your favourite products will be displayed here",
              fontSize: 18,
              textAlign: TextAlign.center,
            ),
            60.verticalSpace
          ],
        ));
  }
}
