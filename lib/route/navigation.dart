
import 'package:farmlynco/features/authentication/presentation/buyer_registration_screen.dart';
import 'package:farmlynco/features/authentication/presentation/farmer_registration_screen.dart';
import 'package:farmlynco/features/authentication/presentation/login_screen.dart';
import 'package:farmlynco/features/authentication/presentation/registration_screen.dart';
import 'package:farmlynco/features/authentication/presentation/reset_password_screen.dart';
import 'package:farmlynco/features/buyer/presentation/buyer_home_screen.dart';
import 'package:farmlynco/features/buyer/presentation/buyer_landing_screen.dart';
import 'package:farmlynco/features/buyer/presentation/buyer_setting_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/about_us_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/buyer_search_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/edit_profile_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/favorite_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/help_center_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/language_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/news_bookmarks_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/news_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/products_screen.dart';
import 'package:farmlynco/features/buyer/presentation/inner_screens/seller_screen.dart';
import 'package:farmlynco/features/farmer/presentation/chat_ai/ai_assistant_screen.dart';
import 'package:farmlynco/features/farmer/presentation/crop_doctor/farmer_crop_doctor.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_home_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_inner_screens/add_product_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_inner_screens/farm_add_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_inner_screens/farmer_disease_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_iot_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_landing_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_main_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_weather_screen.dart';
import 'package:farmlynco/features/farmer/presentation/store_setup/store_setup.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/slide_page_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Navigation {
  Navigation._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  //---------------------------------------------------------------------//
  //                LOGIN SCREENS  PATH STRINGS                          //
  //---------------------------------------------------------------------//

  static const String loginScreen = "/loginScreen";
  static const String emailVerificationScreen = "/emailVerificationScreen";
  static const String farmerRegistrationScreen = "/farmerRegistrationScreen";
  static const String registrationScreen = "/registrationScreen";
  static const String resetPasswordScreen = "/resetPasswordScreen";
  static const String buyerRegistrationScreen = "/buyerRegistrationScreen";

  //---------------------------------------------------------------------//
  //                BUYER SCREENS  PATH STRINGS                          //
  //---------------------------------------------------------------------//

  static const String buyerLandingScreen = "/buyerLandingScreen";
  static const String buyerHomeScreen = "/buyerHomeScreen";
  static const String buyerSearchScreen = "/buyerSearchScreen";
  static const String newsScreen = "/newsScreen";
  static const String readDetailScreen = "/readDetailScreen";
  static const String productsScreen = "/productsScreen";
  static const String productDetailScreen = "/productDetailScreen";
  static const String viewStoreScreen = "/viewStoreScreen";
  static const String aboutUs = "/aboutUs";
  static const String sellerScreen = "/sellerScreen";
  static const String editProfileScreen = "/editProfileScreen";
  static const String helpCenterScreen = "/helpCenterScreen";
  static const String languageScreen = "/languageScreen";
  static const String newsBookmarkScreen = "/newsBookmarkScreen";
  static const String favoriteScreen = "/favoriteScreen";
  static const String buyerSettingScreen = "/buyerSettingScreen";

  //---------------------------------------------------------------------//
  //                FARMER SCREENS  PATH STRINGS                         //
  //---------------------------------------------------------------------//

  static const String farmerMainScreen = "/farmerMainScreen";
  static const String farmerLandingScreen = "/farmerLandingScreen";
  static const String farmerHomeScreen = "/farmerHomeScreen";
  static const String farmerWeatherScreen = "/farmerWeatherScreen";
  static const String farmerIotScreen = "/farmerIotScreen";
  static const String farmerMarketplace = "/farmerMarketplace";
  static const String farmerEditProfileScreen = "/farmerEditProfileScreen";
  static const String farmerChatBotScreen = "/farmerChatBotScreen";
  static const String farmerStoreSetup = "/farmerStoreSetup";
  static const String farmerDiseaseScreen = "/farmerDiseaseScreen";
  static const String farmerAddProductScreen = "/farmerAddProductScreen";
  static const String addProductScreen = "/addProductScreen";
  static const String farmerCropDoctor = "/farmerCropDoctor";

  // static const String farmerScreen = "/farmerScreen";
  // static const String farmerScreen = "/farmerScreen";
  // static const String farmerScreen = "/farmerScreen";
  // static const String farmerScreen = "/farmerScreen";

  //---------------------------------------------------------------------//
  //                GENERARTED ROUTE SETTINGS                            //
  //---------------------------------------------------------------------//

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //---------------------------------------------------------------------//
      //                        LOGIN SCREENS                                //
      //---------------------------------------------------------------------//
      case loginScreen:
        return openRoute(widget: const LoginScreen());
      case farmerRegistrationScreen:
        return openRoute(widget: const FarmRegistrationScreen());
      case registrationScreen:
        return openRoute(widget: const RegistrationScreen());
      case resetPasswordScreen:
        return openRoute(widget: const ResetPasswordScreen());
      case buyerRegistrationScreen:
        return openRoute(widget: const BuyerRegistrationScreen());

      //---------------------------------------------------------------------//
      //                        BUYER SCREENS                                //
      //---------------------------------------------------------------------//

      case buyerLandingScreen:
        return openRoute(widget: const BuyerLandingScreen());
      case buyerHomeScreen:
        return openRoute(widget: const BuyerHomeScreen());
      case buyerSearchScreen:
        return openRoute(widget: const BuyerSearchScreen());
      case newsScreen:
        return openRoute(widget: const NewsScreen());
      case productsScreen:
        return openRoute(widget: const ProductsScreen());
      // case viewStoreScreen:
      //   return openRoute(widget: const ViewStoreDetailScreen());
      case sellerScreen:
        return openRoute(widget: const SellerScreen());
      case aboutUs:
        return openRoute(widget: const AboutUsScreen());
      case editProfileScreen:
        return openRoute(widget: const EditProfileScreen());
      case languageScreen:
        return openRoute(widget: const LanguageScreen());
      case helpCenterScreen:
        return openRoute(widget: const HelpCenterScreen());
      case newsBookmarkScreen:
        return openRoute(widget: const NewsBookmarkScreen());
      case favoriteScreen:
        return openRoute(widget: const FavoriteScreen());
      case buyerSettingScreen:
        return openRoute(widget: const BuyerSettingScreen());
      //---------------------------------------------------------------------//
      //                            FARMER SCREENS                           //
      //---------------------------------------------------------------------//
      case farmerMainScreen:
        return openRoute(widget: const FarmerMainScreen());
      case farmerLandingScreen:
        return openRoute(widget: const FarmerLandingScreen());
      case farmerHomeScreen:
        return openRoute(widget: const FarmerHomeScreen());
      case farmerIotScreen:
        return openRoute(widget: const FarmerIotScreen());
      case farmerWeatherScreen:
        return openRoute(widget: const FarmerWeatherScreen());
      case farmerMarketplace:
        return openRoute(widget: const FarmerWeatherScreen());
      case farmerEditProfileScreen:
        return openRoute(widget: const FarmerWeatherScreen());
      case farmerChatBotScreen:
        return openRoute(widget: const AssistantScreen());
      case farmerStoreSetup:
        return openRoute(widget: const StoreSetup());
      case farmerDiseaseScreen:
        return openRoute(widget: const FarmerDiseaseScreen());
      case farmerAddProductScreen:
        return openRoute(widget: const AddProductScreen());
      case addProductScreen:
        return openRoute(widget: const FarmAddScreen());
      case farmerCropDoctor:
        return openRoute(widget: const FarmerCropDoctor());

      default:
        return MaterialPageRoute(builder: (_) => const ScreenNotImplemented());
    }
  }

  //---------------------------------------------------------------------//
  //                VARIOUS ROUTE METHODS                                //
  //---------------------------------------------------------------------//

  static Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static Future<dynamic> navigatePush(Widget widget) {
    return navigatorKey.currentState!.push(openRoute(widget: widget));
  }

  static Future<dynamic> navigateReplacement(Widget widget) {
    return navigatorKey.currentState!
        .pushReplacement(openRoute(widget: widget));
  }

  static Future<dynamic> navigateReplace(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  static Future<void> pop() async {
    return navigatorKey.currentState!.pop();
  }

  static Future<dynamic> navigateWithArgs(
      String routeName, bool arguments) async {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  //---------------------------------------------------------------------//
  //               CUSTOM SCREEN ANIMATION  (SLIDING FROM RIGHT)         //
  //---------------------------------------------------------------------//

  static openRoute({required Widget widget}) {
    return SlidePageRoute(child: widget);
  }

  //---------------------------------------------------------------------//
  //                                                                     //
  //---------------------------------------------------------------------//

  static openSearchScreen() {
    return navigateTo(buyerSearchScreen);
  }

  static openNewsScreen() {
    return navigateTo(newsScreen);
  }

  static openReadDetailScreen() {
    return navigateTo(readDetailScreen);
  }

  static openBuyerLandingScreen() {
    return navigateTo(buyerLandingScreen);
  }

  static openProductDetailScreen() {
    return navigateTo(productDetailScreen);
  }

  static openProductsScreen() {
    return navigateTo(productsScreen);
  }

  static openViewStoreScreen() {
    return navigateTo(viewStoreScreen);
  }

  static openEditProfileScreen() {
    return navigateTo(editProfileScreen);
  }

  static openAboutUsScreen() {
    return navigateTo(aboutUs);
  }

  static openSellerScreen() {
    return navigateTo(sellerScreen);
  }

  static openHelpCenterScreen() {
    return navigateTo(helpCenterScreen);
  }

  static openLanguageScreen() {
    return navigateTo(languageScreen);
  }

  static openNewsBookmarkScreen() {
    return navigateTo(newsBookmarkScreen);
  }

  static openFavoriteScreen() {
    return navigateTo(favoriteScreen);
  }

  static openBuyerSettingScreen() {
    return navigateTo(buyerSettingScreen);
  }

  static openFarmerAddProductScreen() {
    return navigateTo(farmerAddProductScreen);
  }

  static openFarmerDiseaseScreen() {
    return navigateTo(farmerDiseaseScreen);
  }

  static openAddProductScreen() {
    return navigateTo(farmerAddProductScreen);
  }

  static openStoreSetup() {
    return navigateTo(farmerStoreSetup);
  }

  static openFarmerChatScreen() {
    return navigateTo(farmerChatBotScreen);
  }

  static openFarmerCropDoctor() {
    return navigateTo(farmerCropDoctor);
  }
}

//---------------------------------------------------------------------//
//               UNIMPLEMENTED SCREEN                                  //
//---------------------------------------------------------------------//

class ScreenNotImplemented extends ConsumerWidget {
  const ScreenNotImplemented({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: CustomText(body: "Screen Not Implemented", fontSize: 16),
    );
  }
}
