import 'dart:async';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 1.5;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _controller;
  late Animation<double> animation1;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _containerSize = 1.2;
        _containerOpacity = 1;
      });
    });

    checkCurrentUser().then((initialRoute) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, initialRoute);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> checkCurrentUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final User? currentUser = firebaseAuth.currentUser;
      if (currentUser != null && currentUser.uid.isNotEmpty) {
        // Check if the user is authenticated
        String uid = currentUser.uid;
        DocumentSnapshot userSnapshot =
            await firestore.collection('users').doc(uid).get();
        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>;
          String role = userData['role'];
          if (role == 'Farmer') {
            return Navigation.farmerMainScreen;
          } else if (role == 'Buyer') {
            return Navigation.buyerLandingScreen;
          }
        }
      }
      // If the user is not authenticated or their role is not found, return the login screen
      return Navigation.loginScreen;
    } catch (e) {
      // print('Error: $e');
      return Navigation.loginScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff0f251b),
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: height / _fontSize),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _textOpacity,
                child: Text(
                  'FARMLYNCO',
                  style: TextStyle(
                    fontFamily: 'BlackOpsOne',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: animation1.value * 0.17.h,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: _containerOpacity,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: width / _containerSize,
                  width: width / _containerSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image(
                    height: 100.h,
                    width: 100.h,
                    image: AppImages.logo,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
