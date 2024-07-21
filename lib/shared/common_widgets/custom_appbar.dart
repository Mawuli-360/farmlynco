
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final TextStyle? titleTextStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        body: title,
        fontSize: 19,
        color: AppColors.primaryColor,
      ),
      actions: actions,
      leading: leading ??
          IconButton.filledTonal(
            color: Colors.white,
            padding: EdgeInsets.zero,
            style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(Color.fromARGB(0, 198, 255, 239))),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25.h,
              color: AppColors.green,
            ),
          ),
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: centerTitle,
      shape: const Border(
          bottom: BorderSide(color: Color.fromARGB(82, 115, 114, 114))),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}
