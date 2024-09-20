import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_widgets/farmer_weather_card.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_widgets/section_with_horizontal_tile.dart';
import 'package:farmlynco/features/farmer/presentation/farmers_providers/currentpage_provider.dart';
import 'package:farmlynco/features/farmer/presentation/farmers_providers/fetch_diseases_provider.dart';
import 'package:farmlynco/helper/extensions/language_extension.dart';
import 'package:farmlynco/main.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/language_provider.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/news_provider.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/user_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/header_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FarmerHomeScreen extends ConsumerWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailsProvider);
    final fetchNews = ref.watch(fetchNewsDetailProvider);
    final diseases = ref.watch(fetchDiseasesDetailProvider);
    final currentPage = ref.read(currentPageProvider.notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 230.h,
            floating: false,
            pinned: true,
            title: CustomText(
              maxLines: 2,
              body: user != null ? "Welcome, ${user.name}" : "Hi Farmer",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            surfaceTintColor: AppColors.headerTitleColor,
            backgroundColor: AppColors.headerTitleColor,
            elevation: 5,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.language_outlined,
                  color: AppColors.white,
                ),
                onSelected: (value) {
                  ref.read(currentLanguage.notifier).state = value;
                },
                itemBuilder: (BuildContext context) {
                  return TranslateString.supportedLanguages.entries
                      .map((entry) {
                    return PopupMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList();
                },
              ),
            ],
            leading: IconButton(
              onPressed: () {
                drawerController.toggle?.call();
              },
              icon: const Icon(
                Icons.menu,
                color: AppColors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    color: Colors.white,
                  ),
                  Container(
                    height: 230.h,
                    decoration: BoxDecoration(
                      color: AppColors.headerTitleColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100.h),
                        bottomRight: Radius.circular(100.h),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0.h,
                      left: 12.h,
                      right: 12.h,
                      child: const WeatherCard()),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                14.verticalSpace,
                HeaderTitle(
                  title: "Top News",
                  onPressed: () => Navigation.openNewsScreen(),
                ),
                fetchNews.when(
                    data: (data) {
                      return SizedBox(
                        height: 230.h,
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final image = data[index].image;
                              final content = data[index].content;
                              return FarmerCard(image: image, content: content);
                            }),
                      );
                    },
                    error: (error, st) => Text(error.toString()),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
                GestureDetector(
                  onTap: () {
                    currentPage.setPage(3);
                  },
                  child: SizedBox(
                    height: 75.h,
                    // width: 10.h,
                    child: Row(
                      children: [
                        60.horizontalSpace,
                        LottieBuilder.asset(
                          "assets/animations/storeanim.json",
                          height: 75.h,
                          fit: BoxFit.cover,
                        ),
                        10.horizontalSpace,
                        const CustomText(body: "View Marketplace"),
                        5.horizontalSpace,
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.headerTitleColor,
                          size: 19.h,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                HeaderTitle(
                  title: "Trending Disease",
                  onPressed: () => Navigation.openFarmerDiseaseScreen(),
                ),
                diseases.when(
                    data: (data) {
                      return SizedBox(
                        height: 230.h,
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final image = data[index].image;
                              final content = data[index].content;

                              return FarmerCard(image: image, content: content);
                            }),
                      );
                    },
                    error: (error, st) => Text(error.toString()),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
                40.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
