import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/presentation/weather/provider/weather_provider.dart';
import 'package:farmlynco/helper/extensions/language_extension.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/language_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:farmlynco/util/show_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendationCard extends ConsumerStatefulWidget {
  const RecommendationCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  ConsumerState<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends ConsumerState<RecommendationCard> {
  void _retryFetchInsights() {
    final sensorData = ref.read(sensorDataStreamProvider).value;
    if (sensorData != null) {
      ref.read(weatherInsightsProvider.notifier).fetchInsights(sensorData);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Map<String, String>>>(
      sensorDataStreamProvider,
      (_, next) => next.whenData((sensorData) {
        ref.read(weatherInsightsProvider.notifier).fetchInsights(sensorData);
      }),
    );

    final weatherInsights = ref.watch(weatherInsightsProvider);
    final targetLanguage = ref.watch(currentLanguage);

    return GestureDetector(
      onTap: () {
        weatherInsights.whenData((insights) {
          showCustomBottomSheet(
              context, insights.insights, "Weather Insights Result");
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.h),
        padding: EdgeInsets.all(10.h),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
          color: AppColors.appBgColor,
          border: Border.all(
            color: const Color.fromARGB(144, 50, 137, 122),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(26, 0, 0, 0),
              spreadRadius: 1.5.h,
              blurRadius: 2.h,
            ),
          ],
        ),
        child: Column(
          children: [
            CustomText(
              body: widget.title,
              color: AppColors.headerTitleColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            9.verticalSpace,
            weatherInsights.when(
              data: (insights) {
                return insights.insights.translate(
                  targetLanguage,
                  fontSize: 15,
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                );
              },
              loading: () => const CustomLoadingScale(),
              error: (error, _) => Column(
                children: [
                  CustomText(
                    body: error.toString(),
                    fontSize: 14,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  10.verticalSpace,
                  ElevatedButton(
                    onPressed: _retryFetchInsights,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.headerTitleColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.h))),
                    child: const CustomText(
                      body: 'Retry',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
