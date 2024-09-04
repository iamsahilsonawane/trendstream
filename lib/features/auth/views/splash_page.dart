import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/constants/paths.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:localizely_sdk/localizely_sdk.dart';

import '../../../core/router/router.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await Localizely.updateTranslations();

    await remoteConfig.ensureInitialized();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 0),
    ));
    await remoteConfig.fetchAndActivate();

    final userAgent = remoteConfig.getString("user_agent");
    final referrer = remoteConfig.getString("referrer");
    final prefs = ref.read(sharedPreferencesServiceProvider);

    if (userAgent.isNotEmpty && userAgent != prefs.sharedPreferences.getString("user_agent")) {
      debugPrint("Setting User Agent: $userAgent");
      await prefs.sharedPreferences.setString("user_agent", userAgent);
    }
    if (referrer.isNotEmpty && referrer != prefs.sharedPreferences.getString("referrer")) {
      debugPrint("Setting Referrer: $referrer");
      await prefs.sharedPreferences.setString("referrer", referrer);
    }

    Future.delayed(const Duration(seconds: 1), () async {
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
