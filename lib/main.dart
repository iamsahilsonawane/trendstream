import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/features/movies/views/movies_dashboard/movies_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(prefs),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Latest Movies',
        theme: ThemeData.dark().copyWith(
          platform: TargetPlatform.macOS,
          appBarTheme:
              Theme.of(context).appBarTheme.copyWith(color: kBackgroundColor),
          scaffoldBackgroundColor: kBackgroundColor,
        ),
        home: const HomeView(),
        // home: Consumer(
        //   builder: (context, ref, child) => AuthWidget(
        //     nonSignedInBuilder: (_) => const LoginView(),
        //     signedInBuilder: (_) {
        //       return const HomeView();
        //     },
        //   ),
        // ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorKey: AppRouter.navigatorKey,
      ),
    );
  }
}
