import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/live_channel/live_channel.dart';

final liveChannelQueryProvider = StateProvider<String>((ref) {
  return "";
});

final currentSelectedLiveChannelProvider = StateProvider<LiveChannel?>((ref) {
  return null;
});
