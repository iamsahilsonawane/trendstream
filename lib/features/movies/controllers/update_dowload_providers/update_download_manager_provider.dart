import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
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

class UpdateDownloadManager {
  final Ref ref;

  UpdateDownloadManager(this.ref);

  Future<void> checkAndDownloadUpdate(BuildContext context) async {
    final loadingOverlay = LoadingOverlay.of(context);

    // Get latest build number and url from remote config
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.ensureInitialized();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 0),
    ));

    await remoteConfig.fetchAndActivate();
    final downloadUrl = remoteConfig.getString('download_url');
    final serverBuildNumber = remoteConfig.getInt('latest_build_number');
    debugPrint("Download URL: $downloadUrl | Build Number: $serverBuildNumber");

    // Get current (apk/application) build number
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appBuildNumber = packageInfo.buildNumber;
    debugPrint("Current Build Number: $appBuildNumber");

    if (serverBuildNumber <= int.parse(appBuildNumber)) {
      debugPrint("No Update Available");
    } else {
      final shouldLogin = await showDialog(
        context: context,
        builder: (context) => const DownloadUpdateDialog(),
      );

      if (shouldLogin == false || shouldLogin == null) {
        return;
      }

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
  }
}
