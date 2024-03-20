import 'package:flutter/material.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/constants/paths.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';

import '../../../core/router/router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      AppRouter.navigateToPage(Routes.homeView, replace: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppPaths.logoWhite, width: 400),
            verticalSpaceMedium,
            LinearProgressIndicator(
              valueColor:
                  const AlwaysStoppedAnimation<Color>(kPrimaryAccentColor),
              backgroundColor: kPrimaryColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
