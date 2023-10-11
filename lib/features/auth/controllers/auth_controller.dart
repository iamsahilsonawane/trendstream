import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/router/router.dart';

import '../../../../core/services/firebase_auth.dart';
import '../../../../core/services/shared_preferences_service.dart';

final authVMProvider = ChangeNotifierProvider<AuthViewModel>(
  (ref) => AuthViewModel(
    ref,
    auth: ref.read<FirebaseAuth>(firebaseAuthProvider),
    authService: ref.read<FirebaseAuthService>(firebaseAuthServiceProvider),
  ),
);

class AuthViewModel with ChangeNotifier {
  AuthViewModel(this.ref, {required this.auth, required this.authService});

  final Ref ref;
  final FirebaseAuth auth;
  final FirebaseAuthService authService;

  bool isLoading = false;
  dynamic error;

  Future<dynamic> _stateCallback(dynamic Function() method,
      {bool showLoader = true}) async {
    try {
      if (showLoader) isLoading = true;
      notifyListeners();
      final resp = await method();
      error = null;
      return resp;
    } catch (e) {
      error = e;
      rethrow;
    } finally {
      if (showLoader) isLoading = false;
      notifyListeners();
    }
    // return null;
  }

  ///Sign UP
  Future<void> signUpWithEmail(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    await _stateCallback(() async {
      await authService.signUpWithEmailAndPassword(
          email: email, password: password);
    });

    //Pop until the home screen (where initially it was onboarding page)
    AppRouter.navigateAndRemoveUntil(Routes.homeView, arguments: false);
  }

  ///Sign IN
  Future<void> signInWithEmail(
    BuildContext context, {
    required String email,
    required String password,
    bool isAdmin = false,
  }) async {
    await _stateCallback(() => authService.signInWithEmailAndPassword(
        email: email, password: password));

    //Pop until the home screen (where initially it was onboarding page)
    AppRouter.navigateAndRemoveUntil(Routes.homeView, arguments: false);
  }

  ///Forgot password (email reset)
  Future<void> sendPasswordResetEmail(String email) async {
    await _stateCallback(() => authService.sendPasswordResetEmail(email: email),
        showLoader: false);
  }

  Future<void> logout() async {
    await auth.signOut();

    AppRouter.navigateAndRemoveUntil(Routes.loginView);
    await ref.read(sharedPreferencesServiceProvider).clear();
  }
}
