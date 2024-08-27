import 'package:farmlynco/features/communication/chat/chat_home_screen.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:flutter/material.dart';

class BuyerSettingData {
  BuyerSettingData._();

  static List<SettingData> settingList = [
    SettingData(
      title: "View profile information",
      leadingIcon: Icons.person_outline,
      onTap: () => Navigation.openEditProfileScreen(),
    ),
    SettingData(
      title: "Chat Room",
      leadingIcon: Icons.chat,
      onTap: () => Navigation.navigatePush(const ChatHomeScreen()),
    ),
    // SettingData(
    //   title: "Change your language",
    //   leadingIcon: Icons.language_outlined,
    //   onTap: () => Navigation.openLanguageScreen(),
    // ),
    SettingData(
      title: "Help center",
      leadingIcon: Icons.support_agent,
      onTap: () => Navigation.openHelpCenterScreen(),
    ),
    SettingData(
      title: "About us",
      leadingIcon: Icons.info_outline_rounded,
      onTap: () => Navigation.openAboutUsScreen(),
    ),
  ];
}

class SettingData {
  final String title;
  final IconData leadingIcon;
  void Function()? onTap;
  SettingData({
    required this.title,
    required this.leadingIcon,
    this.onTap,
  });
}
