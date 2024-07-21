import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/shared/data/buyer/setting_data.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingCustomTile extends ConsumerWidget {
  final List<SettingData> settingOption;
  final SettingData lastTile;

  const SettingCustomTile({
    super.key,
    required this.settingOption,
    required this.lastTile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (var settingOption in settingOption) _buildTile(settingOption),
        70.verticalSpace,
        _buildLastTile(
            lastTile, () => ref.read(authRepositoryProvider).signOut()),
      ],
    );
  }

  Widget _buildTile(SettingData settingOption) {
    return GestureDetector(
      onTap: settingOption.onTap,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.only(top: 15.h),
        shadowColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        color: AppColors.white,
        child: ListTile(
          leading: IconButton.filled(
              onPressed: null,
              padding: EdgeInsets.zero,
              style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromARGB(31, 39, 176, 103))),
              icon: Icon(
                settingOption.leadingIcon,
                color: AppColors.primaryColor,
                size: 24.h,
              )),
          title: CustomText(
            body: settingOption.title,
            fontSize: 16,
            color: AppColors.primaryColor,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 22.h,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLastTile(SettingData lastTile, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        surfaceTintColor: AppColors.white,
        color: const Color.fromARGB(24, 202, 44, 44),
        child: ListTile(
          leading: Icon(
            lastTile.leadingIcon,
            color: Colors.red,
            size: 24.h,
          ),
          title: CustomText(
            body: lastTile.title,
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 22.h,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
