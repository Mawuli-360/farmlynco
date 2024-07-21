import 'package:farmlynco/core/constant/app_images.dart';
import 'package:flutter/material.dart';

class AuthScreenData {
  AuthScreenData._();

  static List<RegistrationOptionData> registrationOptions = [
    RegistrationOptionData(
        title: "Sell Foodstuff", image: AppImages.marketplace),
    RegistrationOptionData(title: "Buy Foodstuff", image: AppImages.onlineShop),
  ];
}

class RegistrationOptionData {
  final String title;
  final AssetImage image;

  RegistrationOptionData({required this.title, required this.image});
}
