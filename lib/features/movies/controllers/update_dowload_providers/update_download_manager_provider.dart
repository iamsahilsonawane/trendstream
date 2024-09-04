import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/shared_widgets/loading_overlay.dart';
import 'package:latest_movies/features/movies/controllers/update_dowload_providers/update_download_info_provider.dart';
import 'package:latest_movies/features/movies/widgets/download_update_dialog.dart';
import 'package:latest_movies/features/movies/widgets/download_update_widgets/downloading_overlay.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

final updateDownloadManagerProvider = Provider<UpdateDownloadManager>((ref) {
  return UpdateDownloadManager(ref);
});

class UpdateCheckResult {
  final bool updateAvailable;
  final int? updateBuildNumber;
  final String? downloadUrl;

  UpdateCheckResult({
    required this.updateAvailable,
    this.updateBuildNumber,
    this.downloadUrl,
  });
}

class UpdateDownloadManager {
  final Ref ref;

  UpdateDownloadManager(this.ref);

  final remoteConfig = FirebaseRemoteConfig.instance;
  final platform = const MethodChannel('com.example.latest_movies/channel');

  Future<UpdateCheckResult> checkForUpdate() async {
    final downloadUrl = remoteConfig.getString('download_url');
    final serverBuildNumber = remoteConfig.getInt('latest_build_number');
    debugPrint("Download URL: $downloadUrl | Build Number: $serverBuildNumber");

    // Get current (apk/application) build number
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appBuildNumber = packageInfo.buildNumber;
    debugPrint("Current Build Number: $appBuildNumber");

    return UpdateCheckResult(
      updateAvailable: serverBuildNumber > int.parse(appBuildNumber),
      downloadUrl: downloadUrl,
      updateBuildNumber: serverBuildNumber,
    );
  }

  /// Downloads the update
  ///
  /// If [downloadUrl] is null, it will fetch the download url from remote config
  Future<void> downloadUpdate(LoadingOverlay loadingOverlay,
      {String? downloadUrl}) async {
    final downloadUrl = remoteConfig.getString('download_url');
    debugPrint("Downloading from: $downloadUrl");
    try {
      loadingOverlay.showWithCustomChild(child: const DownloadingOverlay());
      OtaUpdate()
          .execute(
        downloadUrl,
        destinationFilename: 'latest_movies.apk',
        sha256checksum: null,
      )
          .listen(
        (OtaEvent event) {
          debugPrint(
              "event status: ${event.status} | event value: ${event.value}");
          if (event.status != OtaStatus.DOWNLOADING) {
            if (loadingOverlay.isOpen) {
              loadingOverlay.hide();
            }
          }
          if (double.tryParse(event.value ?? "") != null) {
            ref.read(updateDownloadPercentageProvider.state).state =
                double.parse(event.value!) * 0.01;
          }
        },
      );
    } catch (e) {
      debugPrint('Failed to make OTA update. Details: $e');
    }
  }

  /// If [askForUpdate] is true, it will show a dialog asking the user if they want to download the update.
  Future<bool> checkAndDownloadUpdate(BuildContext context,
      {required bool askForUpdate, required bool Function() isMounted}) async {
    final loadingOverlay = LoadingOverlay.of(context);

    final result = await checkForUpdate();

    if (!result.updateAvailable) {
      debugPrint("No Update Available");
      return false;
    }

    if (askForUpdate && isMounted()) {
      // ignore: use_build_context_synchronously
      final shouldUpdate = await showDialog(
        context: context,
        builder: (context) => DownloadUpdateDialog(
          newUpdateVersion:
              "v${FirebaseRemoteConfig.instance.getString('latest_version_code')} #${FirebaseRemoteConfig.instance.getInt('latest_build_number')}",
        ),
      );

      if (shouldUpdate == false || shouldUpdate == null) {
        return true;
      }

      bool hasPermissions = false;

      hasPermissions = await hasInstallFromSourcePermission();

      if (!hasPermissions) {
        const AndroidIntent intent = AndroidIntent(
          action: 'android.settings.MANAGE_UNKNOWN_APP_SOURCES',
          data: 'package:com.example.latest_movies',
        );
        await intent.launch();
      }
      if (hasPermissions) {
        await downloadUpdate(loadingOverlay, downloadUrl: result.downloadUrl);
        return false;
      }
    }
    return true;
  }

  Future<bool> hasInstallFromSourcePermission() async {
    bool hasPermissions = false;
    try {
      hasPermissions =
          await platform.invokeMethod("checkForRequestPackageInstalls");
      debugPrint(
          "has checkForRequestPackageInstalls permission: $hasPermissions");
    } on PlatformException catch (e) {
      debugPrint("PlatformException: $e");
    }

    return hasPermissions;
  }
}
