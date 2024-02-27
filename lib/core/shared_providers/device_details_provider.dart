import 'package:device_info_plus/device_info_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final androidDeviceInfoProvider = Provider<AndroidDeviceInfo>((ref) {
  throw UnimplementedError();
});

extension XDInfo on AndroidDeviceInfo {
  bool get isTv {
    return systemFeatures.contains('android.software.leanback');
  }
}
