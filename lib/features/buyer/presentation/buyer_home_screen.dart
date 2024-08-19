import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/application/provider/products_provider.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/seller_screen.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/custom_sliver_appbar.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/horizontal_scroll_product_with_title.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/seller_card.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/news_carousel.dart';
import 'package:farmlynco/shared/common_widgets/tip_of_the_day_card.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuyerHomeScreen extends ConsumerWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: BuyerHomeContent(),
    );
  }
}

class BuyerHomeContent extends StatelessWidget {
  const BuyerHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const CustomSliverAppBar(),
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.verticalSpace,
            const CustomText(
              body: "Top Offers",
              fontWeight: FontWeight.w500,
              color: AppColors.headerTitleColor,
              bottom: 10,
              left: 15,
            ),
            2.verticalSpace,
            const NewsCarousel(),
            18.verticalSpace,
            const HorizontalScrollProductWithTitle(),
            25.verticalSpace,
            const TipOfTheDayCard(
                tip:
                    "Noticed something isn't quite right? Report the issue through our feedback form so we can look into it. Thank you 🙂"),
            15.verticalSpace,
            const CustomText(
              body: "Best Sellers",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.headerTitleColor,
              bottom: 10,
              left: 15,
              top: 10,
            ),
            const _SellerAppreciationSection(),
            35.verticalSpace,
          ],
        ),
      ),
    ]);
  }
}

class _SellerAppreciationSection extends ConsumerWidget {
  const _SellerAppreciationSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellers = ref.watch(fetchSomeUserProvider);

    return sellers.when(
      data: (data) {
        return SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 15.r),
            itemCount: 3,
            itemBuilder: (context, index) {
              final user = data[index];
              return GestureDetector(
                onTap: () => Navigation.navigatePush(SellerScreen(user)),
                child: SellerCard(
                  user: user,
                ),
              );
            },
          ),
        );
      },
      error: (error, st) => Text(error.toString()),
      loading: () => const Center(
        child: CustomLoadingScale(),
      ),
    );
  }
}
