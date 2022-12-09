import 'package:flutter/foundation.dart';
import 'package:latest_movies/core/config/config.dart';
import 'package:latest_movies/core/extensions/date_extension.dart';
import 'package:latest_movies/core/services/http/http_service.dart';
import 'package:latest_movies/features/tv_guide/models/program_guide/program_guide.dart';
import 'package:latest_movies/features/tv_guide/repositories/tv_guide_repository.dart';

import '../models/program_guide/channel.dart';
import '../models/program_guide/program.dart';

class HttpTvGuideRepository implements TvGuideRepository {
  final HttpService httpService;

  HttpTvGuideRepository(this.httpService);

  @override
  String get apiKey => Configs.apiKey;

  @override
  String get path => "https://iptv-org.github.io/epg/guides";

  @override
  Future<ProgramGuide> getProgramGuide({bool forceRefresh = false}) async {
    final responseData = await httpService.get(
      '$path/us.json',
      forceRefresh: forceRefresh,
      queryParameters: {},
    );

    return await compute(deserializeProgramGuide, responseData);
  }
}

ProgramGuide deserializeProgramGuide(dynamic json) {
  final epg = ProgramGuide.fromJson(json);

  List<Channel> channels = [];
  List<Program> programs = epg.programs ?? [];

  if (programs.length > 2000) {
    programs = programs.sublist(0, 2000);
  }

  final programsToChannels = <String, List<Program>>{};

  for (final program in programs) {
    final channel = (epg.channels ?? []).firstWhere(
      (channel) => channel.id == program.channel,
      orElse: () => const Channel(id: "notfound"),
    );

    if (channel.id == "notfound" || channel.id == null) {
      continue;
    }

    if (programsToChannels.containsKey(channel.id)) {
      if (DateTime.fromMillisecondsSinceEpoch(program.start!)
          .toLocal()
          .isSameDayAs(DateTime.now().toLocal())) {
        programsToChannels[channel.id]!.add(program);
      }
    } else {
      if (DateTime.fromMillisecondsSinceEpoch(program.start!)
          .toLocal()
          .isSameDayAs(DateTime.now().toLocal())) {
        programsToChannels[channel.id!] = [program];
      }
    }
  }

  for (final channel in epg.channels ?? []) {
    if (programsToChannels.containsKey(channel.id)) {
      channels.add(channel);
    }
  }

  return ProgramGuide(
    channels: channels,
    programs: programs,
    programsToChannels: programsToChannels,
  );
}
