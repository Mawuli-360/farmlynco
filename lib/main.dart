import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:farmlynco/app.dart';
import 'package:farmlynco/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(
      const ProviderScope(
        child: Farmlynco(),
      ),
    );
  }, (Object error, StackTrace stack) {
    print('Caught error: $error');
    print(stack);
  });
}

final drawerController = ZoomDrawerController();
