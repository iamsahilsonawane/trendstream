import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/controllers/search_paginated_movies_provider.dart';
import 'package:latest_movies/features/movies/models/live_channel/live_channel.dart';

import '../../../core/models/paginated_response.dart';
import 'live_channel_controller.dart';

final currentLiveChannelProvider = Provider<AsyncValue<LiveChannel>>((ref) {
  throw UnimplementedError();
});

final channels = [
  const LiveChannel(
    id: "1",
    channelName: "ESPN",
    channelBanner:
        "https://firebasestorage.googleapis.com/v0/b/latest-movies-cff93.appspot.com/o/static%2Fespn-banner.png?alt=media&token=ecf6360d-b0e2-4497-874f-9643cd9be756&_gl=1*1c6nytl*_ga*MTQ1NjU0ODA5Ny4xNjgzNDI3MDEx*_ga_CW55HF8NVT*MTY4NTc3MTM3NC4xNi4xLjE2ODU3NzE3MzQuMC4wLjA.",
  ),
  const LiveChannel(
    id: "2",
    channelName: "FOX",
    channelBanner:
        "https://firebasestorage.googleapis.com/v0/b/latest-movies-cff93.appspot.com/o/static%2Ffox-banner.png?alt=media&token=0a5c125f-d5df-43ad-9cb1-474941019892&_gl=1*13iovw1*_ga*MTQ1NjU0ODA5Ny4xNjgzNDI3MDEx*_ga_CW55HF8NVT*MTY4NTc3MTM3NC4xNi4xLjE2ODU3NzE3NDEuMC4wLjA.",
  ),
  const LiveChannel(
    id: "3",
    channelName: "CBS",
    channelBanner:
        "https://firebasestorage.googleapis.com/v0/b/latest-movies-cff93.appspot.com/o/static%2Fcbs-banner.png?alt=media&token=c445756e-62f4-4bd1-aeaf-78d624d21ee9&_gl=1*7yi3l3*_ga*MTQ1NjU0ODA5Ny4xNjgzNDI3MDEx*_ga_CW55HF8NVT*MTY4NTc3MTM3NC4xNi4xLjE2ODU3NzE3MTguMC4wLjA.",
  ),
  const LiveChannel(
    id: "4",
    channelName: "TNT",
    channelBanner:
        "https://firebasestorage.googleapis.com/v0/b/latest-movies-cff93.appspot.com/o/static%2Ftnt-banner.png?alt=media&token=f12e17d0-fd3d-4557-ba71-ad5362d549b5&_gl=1*1ivjb8c*_ga*MTQ1NjU0ODA5Ny4xNjgzNDI3MDEx*_ga_CW55HF8NVT*MTY4NTc3MTM3NC4xNi4xLjE2ODU3NzE3NDguMC4wLjA.",
  ),
];

final searchedLiveChannelsCountProvider = Provider<AsyncValue<int>>((ref) {
  final query = ref.watch(liveChannelQueryProvider);

  return AsyncData(channels
      .where((element) =>
          element.channelName!.toLowerCase().contains(query.toLowerCase()))
      .toList()
      .length);
});

final paginatedLiveChannelsProvider = FutureProvider.family<
    PaginatedResponse<LiveChannel>, PaginatedSearchProviderArgs>(
  (ref, PaginatedSearchProviderArgs args) async {
    return PaginatedResponse(
      results: channels
          .where((element) => element.channelName!.toLowerCase().contains(
                args.query.toLowerCase(),
              ))
          .toList(),
    );
  },
);
