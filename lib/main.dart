import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:latest_movies/core/shared_providers/device_details_provider.dart';
import 'package:latest_movies/core/shared_providers/locale_provider.dart';
import 'package:latest_movies/core/utilities/app_utility.dart';
import 'package:latest_movies/features/auth/views/splash_page.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    if (systemOverlaysAreVisible) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
  });

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

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(prefs),
        ),
        androidDeviceInfoProvider.overrideWithValue(androidInfo),
      ],
      child: const MyApp(),
    ),
  );

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    print("locale: $locale");

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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const SplashView(),
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
