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

class WeatherCard extends ConsumerStatefulWidget {
  const WeatherCard({
    super.key,
  });

  @override
  ConsumerState<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends ConsumerState<WeatherCard> {
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
                          data: (insights) {
                            return insights.insights.translate(
                              targetLanguage,
                              fontSize: 15,
                              maxLines: 4,
                              textOverflow: TextOverflow.ellipsis,
                            );
                          },
                          loading: () => const CustomLoadingScale(),
                          error: (error, _) => Column(
                            children: [
                              error.toString()
                                  .translate(
                                targetLanguage,
                                fontSize: 14,
                                maxLines: 2,
                                textOverflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              10.verticalSpace,
                              ElevatedButton(
                                  onPressed: _retryFetchInsights,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.headerTitleColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.h))),
                                  child: "Retry".translate(
                                    targetLanguage,
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
