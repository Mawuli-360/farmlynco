import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/data/buyer/language_data.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: const CustomAppBar(
        title: "Select Language",
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: const CustomText(
                body:
                    "Unlock a world of opportunities by selecting the language that will broaden your horizons.",
                fontSize: 16,
                textAlign: TextAlign.center,
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: LanguageScreenData.languageOption.length,
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  separatorBuilder: (context, index) => 18.verticalSpace,
                  itemBuilder: (context, index) {
                    return LanguageTile(
                        title: LanguageScreenData.languageOption[index].title,
                        isSelected: index == 1,
                        onTap: () {
                          // ref.read(selectedIndex.notifier).state = index;
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
