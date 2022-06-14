import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:latest_movies/app/ui/movies/movie_details/movie_details.dart';
import '../app/ui/movies/movies_dashboard/movies_dashboard.dart';
import '_routes.dart';

import '../app/ui/auth/login.dart';
import '../app/ui/auth/signup.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static Future<dynamic> navigateToPage(String routeName,
      {bool replace = false, dynamic arguments}) async {
    log("Navigation: $routeName | Type: Push | Replace: $replace | Args: $arguments");

    if (replace) {
      return navigatorKey.currentState!
          .pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return navigatorKey.currentState!
          .pushNamed(routeName, arguments: arguments);
    }
  }

  static void pop([dynamic result]) {
    log("Navigation | Type: Pop | Args: $result");
    navigatorKey.currentState!.pop(result);
  }

  static void maybePop([dynamic result]) {
    log("Navigation | Type: Maybe Pop | Args: $result");
    navigatorKey.currentState!.maybePop(result);
  }

  static void navigateAndRemoveUntil(String routeName, {dynamic arguments}) {
    log("Navigation | Type: Permanent Navigation | Args: No args");
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }

  static void popUntil(bool Function(Route<dynamic>) route) {
    log("Navigation | Type: Pop (Until) | Pop Route: $route");
    navigatorKey.currentState!.popUntil(route);
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginView:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const LoginView(),
          settings: settings,
          fullscreenDialog: false,
        );
      case Routes.signUpView:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SignUpView(),
          settings: settings,
          fullscreenDialog: false,
        );
      case Routes.homeView:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomeView(),
          settings: settings,
          fullscreenDialog: false,
        );
      case Routes.detailsView:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const MovieDetailsView(),
          settings: settings,
          fullscreenDialog: false,
        );
      default:
        return null;
    }
  }
}
