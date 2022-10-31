import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'channel.dart';
import 'program.dart';

part 'program_guide.g.dart';

@JsonSerializable()
class ProgramGuide extends Equatable {
  final List<Channel>? channels;
  final List<Program>? programs;

  const ProgramGuide({this.channels, this.programs});

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
