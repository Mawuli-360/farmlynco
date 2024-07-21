
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.menu,
    required this.onTap,
    this.color = const Color.fromARGB(33, 245, 245, 245),
  });

  final IconData icon;
  final String menu;
  final void Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      child: Container(
        color: color,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        child: ListTile(
          leading: Icon(
            icon,
            color: AppColors.white,
          ),
          title: CustomText(
            body: menu,
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
