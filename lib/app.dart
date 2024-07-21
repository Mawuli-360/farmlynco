import 'package:device_preview/device_preview.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Farmlynco extends StatelessWidget {
  const Farmlynco({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            theme: ThemeData(fontFamily: 'Poppins'),
            home: const SplashScreen(),
            navigatorKey: Navigation.navigatorKey,
            onGenerateRoute: Navigation.onGenerateRoute,
            initialRoute: "/farmerMainScreen",
          );
        });
  }
}
