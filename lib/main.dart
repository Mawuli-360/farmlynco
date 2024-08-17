import 'package:farmlynco/app.dart';
import 'package:farmlynco/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final chatService = ChatService();
  // chatService.updateUserStatus(true);
  // SystemChannels.lifecycle.setMessageHandler((msg) {
  //   if (msg == AppLifecycleState.detached.toString()) {
  //     chatService.updateUserStatus(false);
  //   }
  //   return Future.value(null);
  // });
  runApp(
    const ProviderScope(
      child: Farmlynco(),
    ),
  );
}

final drawerController = ZoomDrawerController();
