import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/router.dart';
import '../../../services/firebase_auth.dart';
import '../../../services/shared_preferences_service.dart';

final authVMProvider = ChangeNotifierProvider<AuthViewModel>(
  (ref) => AuthViewModel(
    ref.read,
    auth: ref.read<FirebaseAuth>(firebaseAuthProvider),
    authService: ref.read<FirebaseAuthService>(firebaseAuthServiceProvider),
  ),
);

class AuthViewModel with ChangeNotifier {
  AuthViewModel(this.read, {required this.auth, required this.authService});

  final Reader read;
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
      UserCredential creds = await authService.signUpWithEmailAndPassword(
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
    await _stateCallback(() => authService.sendPasswordResetEmail(email: email), showLoader: false);
  }

  Future<void> logout() async {
    await auth.signOut();

    AppRouter.navigateAndRemoveUntil(Routes.loginView);
    await read(sharedPreferencesServiceProvider).clear();
  }
}
