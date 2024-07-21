import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/setting_custom_tile.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/setting_header.dart';
import 'package:farmlynco/shared/data/buyer/setting_data.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuyerSettingScreen extends ConsumerWidget {
  const BuyerSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.white,
      body: _SettingContent(),
    );
  }
}

class _SettingContent extends StatelessWidget {
  const _SettingContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: const Stack(
        clipBehavior: Clip.none,
        children: [
          SettingHeader(),
          _OptionSection(),
        ],
      ),
    );
  }
}

class _OptionSection extends StatelessWidget {
  const _OptionSection();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0.5.sw - 0.45.sw,
      child: Container(
        height: 0.7.sh,
        width: 0.9.sw,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              body: "Settings",
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.headerTitleColor,
              left: 20,
              top: 20,
            ),
            SettingCustomTile(
                settingOption: BuyerSettingData.settingList,
                lastTile: SettingData(
                  title: "Logout",
                  leadingIcon: Icons.exit_to_app_rounded,
                ))
          ],
        ),
      ),
    );
  }
}
