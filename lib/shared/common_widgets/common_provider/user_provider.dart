import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDetailsNotifier extends StateNotifier<User?> {
  StreamSubscription<auth.User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;

  UserDetailsNotifier() : super(null) {
    _subscribeToAuthStateChanges();
  }

  void _subscribeToAuthStateChanges() {
    _authSubscription =
        auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToUserDataChanges(user.uid);
      } else {
        _unsubscribeFromUserDataChanges();
        state = null;
      }
    });
  }

  void _subscribeToUserDataChanges(String uid) {
    _unsubscribeFromUserDataChanges();

    final userDocument =
        FirebaseFirestore.instance.collection('users').doc(uid);
    _userDataSubscription = userDocument.snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data()!;
          state = User(
            email: data['email'] ?? '',
            name: data['fullName'] ?? '',
            phone: data['phone'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
          );
        } else {
          state = null;
        }
      },
      onError: (error) {
        state = null;
      },
    );
  }

  void _unsubscribeFromUserDataChanges() {
    _userDataSubscription?.cancel();
    _userDataSubscription = null;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _unsubscribeFromUserDataChanges();
    super.dispose();
  }
}

// User model
class User {
  final String email;
  final String name;
  final String phone;
  final String imageUrl;

  User({
    required this.email,
    required this.name,
    required this.phone,
    required this.imageUrl,
  });
}

// Provider definition
final userDetailsProvider =
    StateNotifierProvider<UserDetailsNotifier, User?>((ref) {
  return UserDetailsNotifier();
});
