// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_guide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramGuide _$ProgramGuideFromJson(Map<String, dynamic> json) => ProgramGuide(
      channels: (json['channels'] as List<dynamic>?)
          ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
          .toList(),
      programs: (json['programs'] as List<dynamic>?)
          ?.map((e) => Program.fromJson(e as Map<String, dynamic>))
          .toList(),
      programsToChannels:
          (json['programsToChannels'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => Program.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$ProgramGuideToJson(ProgramGuide instance) =>
    <String, dynamic>{
      'channels': instance.channels,
      'programs': instance.programs,
      'programsToChannels': instance.programsToChannels,
    };
