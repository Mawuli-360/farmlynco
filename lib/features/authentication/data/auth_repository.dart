import 'dart:async';
import 'dart:io';

import 'package:farmlynco/features/authentication/presentation/email_verification_screen.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/util/loading_overlay.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
final nameProvider = StateProvider<String>((ref) => '');
final phoneNumberProvider = StateProvider<String>((ref) => '');
final authExceptionProvider = StateProvider<String?>((ref) => null);
final isLoginLoading = StateProvider<bool>((ref) => false);
final isResetPasswordLoading = StateProvider<bool>((ref) => false);
final isBuyerSigningUp = StateProvider<bool>((ref) => false);
final isFarmerSigningUp = StateProvider<bool>((ref) => false);

class AuthRepository {
  AuthRepository(this._auth, this._firebaseFirestore, this._ref);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;
  GoogleSignIn googleSignIn = GoogleSignIn();

  final Ref _ref;
  final LoadingOverlay _loadingOverlay = LoadingOverlay();
  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> handleAuthentication(
      String selectedRole, BuildContext context) async {
    bool isAuthSuccessful = await authenticateUser(selectedRole, _ref);

    if (isAuthSuccessful) {
      if (currentUser != null && currentUser!.emailVerified) {
        // User is authenticated and the selected role matches
        String uid = currentUser!.uid;
        DocumentSnapshot userSnapshot =
            await _firebaseFirestore.collection('users').doc(uid).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          String role = userData['role'];

          if (role == 'Buyer') {
            Navigation.navigateReplace(Navigation.buyerLandingScreen);
          } else if (role == 'Farmer') {
            Navigation.navigateReplace(Navigation.farmerMainScreen);
          }
        } else {
          // User document not found in Firestore
          showToast('User document not found');
        }
      }
      if (currentUser != null && !currentUser!.emailVerified) {
        Navigation.navigateReplacement(
            EmailVerificationScreen(currentUser!, _auth));
      } else {
        // User is not authenticated or the selected role doesn't match
        // showToast(context, 'Authentication failed');
      }
    } else {
      // Authentication failed

      showToast('Authentication failed');
    }
  }

  Future<bool> authenticateUser(String selectedRole, Ref ref) async {
    final String email = ref.read(emailProvider.notifier).state.trim();
    final String password = ref.read(passwordProvider.notifier).state.trim();
    ref.read(isLoginLoading.notifier).state = true;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String uid = userCredential.user!.uid;
      DocumentSnapshot userSnapshot =
          await _firebaseFirestore.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        String role = userData['role'];

        // Check if the selected role matches the user's role
        if (role == selectedRole) {
          // Authentication successful
          ref.read(isLoginLoading.notifier).state = false;
          return true;
        } else {
          // Roles don't match, show an error message
          showToast('Selected role does not match user role');
          ref.read(isLoginLoading.notifier).state = false;
          await _auth.signOut();

          return false;
        }
      } else {
        showToast('User not found');
        ref.read(isLoginLoading.notifier).state = false;
        return false;
      }
    } catch (e) {
      ref.read(isLoginLoading.notifier).state = false;
      return false;
    }
  }

  Future<void> navigateToRoleScreen() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userSnapshot =
            await _firebaseFirestore.collection('users').doc(uid).get();
        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>;
          String role = userData['role'];
          if (role == 'Farmer') {
            // Navigate to the farmer screen
            Navigation.navigateReplace(Navigation.farmerMainScreen);
          } else if (role == 'Buyer') {
            Navigation.navigateReplace(Navigation.buyerLandingScreen);
          } else {
            // Handle the case when the user has a different role
            showToast('Invalid user role');
          }
        } else {
          // Handle the case when the user document does not exist
          showToast('User document not found');
        }
      } else {
        // Handle the case when the user is not authenticated
        showToast('User not authenticated');
      }
    } catch (e) {
      // print('Error: $e');
      showToast('$e');
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      _ref.read(isLoginLoading.notifier).state = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Check if the user exists
      if (userCredential.user != null) {
        // Navigate to the home screen
        await navigateToRoleScreen();
        _ref.read(isLoginLoading.notifier).state = false;
      } else {
        // Handle the case when the user does not exist

        _ref.read(authExceptionProvider.notifier).state =
            'User does not exist.';
        _ref.read(isLoginLoading.notifier).state = false;
      }
    } catch (e) {
      showToast("$e");
      _ref.read(isLoginLoading.notifier).state = false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    _loadingOverlay.show(context);

    try {
      final user = _auth.currentUser;

      if (user != null) {
        bool isGoogleUser = user.providerData
            .any((userInfo) => userInfo.providerId == 'google.com');

        if (isGoogleUser) {
          // Reinitialize GoogleSignIn
          googleSignIn = GoogleSignIn();

          try {
            await googleSignIn.disconnect();
            await googleSignIn.signOut();
          } catch (googleError) {
            // print('Error with Google Sign-In: $googleError');
            showToast('Error with Google Sign-In: $googleError');
          }
        }

        await _auth.signOut();
      }

      _loadingOverlay.hide();
      Navigation.navigateTo(Navigation.loginScreen);
    } catch (e) {
      _loadingOverlay.hide();
      // print('Error during sign out: $e');
      showToast('Error during sign out: $e');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      if (email.isEmpty) {
        showToast("Fill in the email field");
        return;
      }
      _ref.read(isResetPasswordLoading.notifier).state = true;
      await _auth.sendPasswordResetEmail(email: email.trim());
      _ref.read(isResetPasswordLoading.notifier).state = false;

      Navigation.navigateReplace(Navigation.loginScreen);
      showToast('Password reset email sent');
    } catch (e) {
      showToast('Error: ${e.toString()}');
    }
  }

  // Future<void> signInWithGoogle(BuildContext context) async {
  //   _loadingOverlay.show(context);

  //   try {
  //     final googleUser = await googleSignIn.signIn();

  //     if (googleUser == null) {
  //       _loadingOverlay.hide();
  //       showToast("Failed Authentication");
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase
  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //     final User? user = userCredential.user;

  //     if (user != null) {
  //       // Prepare user data
  //       final userData = {
  //         'email': user.email,
  //         'fullName': user.displayName ?? 'Unnamed User',
  //         'imageUrl': user.photoURL ??
  //             "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1200px-User-avatar.svg.png",
  //         'role': 'Buyer',
  //       };

  //       // Store or update user data in Firestore
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .set(userData, SetOptions(merge: true));

  //       _loadingOverlay.hide();

  //       Navigation.navigateReplace(Navigation.buyerLandingScreen);
  //     }
  //     _loadingOverlay.hide();
  //   } on SocketException catch (_) {
  //     _loadingOverlay.hide();

  //     showToast('Please check your internet connection.');
  //   } on TimeoutException catch (_) {
  //     _loadingOverlay.hide();

  //     showToast('Request failed. Please try again later');
  //   } catch (e) {
  //     _loadingOverlay.hide();

  //     showToast('Failed to sign in with Google. Please try again.');
  //   }
  // }

  Future<void> signInWithGoogle(BuildContext context) async {
    _loadingOverlay.show(context);

    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        _loadingOverlay.hide();
        showToast("User cancelled the sign-in process");
        return;
      }

      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Prepare user data
          final userData = {
            'email': user.email,
            'fullName': user.displayName ?? 'Unnamed User',
            'imageUrl': user.photoURL ??
                "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1200px-User-avatar.svg.png",
            'role': 'Buyer',
          };

          // Store or update user data in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userData, SetOptions(merge: true));

          _loadingOverlay.hide();

          Navigation.navigateReplace(Navigation.buyerLandingScreen);
        } else {
          showToast("Failed to get user information from Firebase");
        }
      } catch (e) {
        if (e is PlatformException) {}
        showToast("Error during Google authentication: ${e.toString()}");
      }
    } on SocketException catch (_) {
      showToast('Please check your internet connection.');
    } on TimeoutException catch (_) {
      showToast('Request failed. Please try again later');
    } catch (e) {
      showToast('Failed to sign in with Google: ${e.toString()}');
    } finally {
      _loadingOverlay.hide();
    }
  }
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider),
      ref.watch(firebaseFirestoreProvider), ref);
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
