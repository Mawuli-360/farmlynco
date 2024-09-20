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

class SprayingAdviceCard extends ConsumerWidget {
  const SprayingAdviceCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sprayInsights = ref.watch(sprayInsightsProvider);
    final targetLanguage = ref.watch(currentLanguage);

    return GestureDetector(
      onTap: () {
        sprayInsights.whenData((cachedInsights) {
          showCustomBottomSheet(context, cachedInsights.insights.insights,
              "Spraying Insights Result${cachedInsights.isOutdated ? ' (Outdated)' : ''}");
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
              body: title,
              color: AppColors.headerTitleColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            9.verticalSpace,
            sprayInsights.when(
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
                      const CustomText(
                        body: "Updating...",
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                  ],
                );
              },
              loading: () => const CustomLoadingScale(),
              error: (error, _) => Column(
                children: [
                  const CustomText(
                    body: "Unable to fetch new insights. Retrying...",
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
    );
  }
}
