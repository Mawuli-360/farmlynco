import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/bookmark_tile.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NewsBookmarkScreen extends ConsumerStatefulWidget {
  const NewsBookmarkScreen({super.key});

  @override
  ConsumerState<NewsBookmarkScreen> createState() => _NewsBookmarkScreenState();
}

class _NewsBookmarkScreenState extends ConsumerState<NewsBookmarkScreen> {
  bool isBookmarkListEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(title: "News Bookmarks"),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: isBookmarkListEmpty
                ? const _EmptyBookmarkContent()
                : const BookmarkContent(),
          ),
        ));
  }
}

class BookmarkContent extends StatelessWidget {
  const BookmarkContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        30.verticalSpace,
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => const BookmarkTile(),
          ),
        ),
      ],
    );
  }
}

class _EmptyBookmarkContent extends StatelessWidget {
  const _EmptyBookmarkContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/animations/empty_bookmark.json",
            height: 250.h, fit: BoxFit.cover),
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.h),
          child: const CustomText(
              body: "You don't have any bookmarked news. ",
              textAlign: TextAlign.center,
              fontSize: 18),
        ),
        70.verticalSpace
      ],
    );
  }
}
