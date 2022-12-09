import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'channel.dart';
import 'program.dart';

part 'program_guide.g.dart';

@JsonSerializable()
class ProgramGuide extends Equatable {
  final List<Channel>? channels;
  final List<Program>? programs;

  ///each channel(channel id here) > list of programs in that channel
  final Map<String, List<Program>>? programsToChannels;
  const ProgramGuide({
    this.channels,
    this.programs,
    this.programsToChannels,
  });

  factory ProgramGuide.fromJson(Map<String, dynamic> json) {
    return _$ProgramGuideFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProgramGuideToJson(this);

  ProgramGuide copyWith({
    List<Channel>? channels,
    List<Program>? programs,
  }) {
    return ProgramGuide(
      channels: channels ?? this.channels,
      programs: programs ?? this.programs,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [channels, programs];
}
