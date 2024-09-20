import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/presentation/weather/provider/weather_provider.dart';
import 'package:farmlynco/helper/extensions/language_extension.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/language_provider.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:farmlynco/util/show_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherInsights = ref.watch(weatherInsightsProvider);
    final targetLanguage = ref.watch(currentLanguage);

    return GestureDetector(
      onTap: () {
        weatherInsights.whenData((cachedInsights) {
          showCustomBottomSheet(context, cachedInsights.insights.insights,
              "Weather Insights Result${cachedInsights.isOutdated ? ' (Outdated)' : ''}");
        });
      },
      child: Card(
        elevation: 4,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: SizedBox(
          height: 160.h,
          child: Row(
            children: [
              LottieBuilder.asset(
                "assets/animations/forecast.json",
                height: 100.h,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.h),
                  child: Column(
                    children: [
                      "Today's Weather".translate(
                        targetLanguage,
                        color: AppColors.headerTitleColor,
                        top: 18,
                        bottom: 12,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      weatherInsights.when(
                        data: (cachedInsights) {
                          return Column(
                            children: [
                              cachedInsights.insights.insights.translate(
                                targetLanguage,
                                fontSize: 15,
                                maxLines: 3,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                              if (cachedInsights.isOutdated)
                                "Updating...".translate(
                                  targetLanguage,
                                  fontSize: 12,
                                  color: Colors.orange,
                                ),
                            ],
                          );
                        },
                        loading: () => const CustomLoadingScale(),
                        error: (error, _) => Column(
                          children: [
                            "Unable to fetch new insights. Retrying..."
                                .translate(
                              targetLanguage,
                              fontSize: 14,
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            10.verticalSpace,
                            const CustomLoadingScale(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
