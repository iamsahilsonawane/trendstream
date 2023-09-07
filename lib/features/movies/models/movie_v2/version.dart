import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'audio_language.dart';
import 'codec.dart';
import 'quality.dart';

part 'version.g.dart';

@JsonSerializable()
class Version extends Equatable {
  final AudioLanguage? audioLanguage;
  final Codec? codec;
  final String? comment;
  final num? id;
  @JsonKey(name: 'id_movie')
  final num? idMovie;
  final Quality? quality;
  final String? url;
  final String? version;

  const Version({
    this.audioLanguage,
    this.codec,
    this.comment,
    this.id,
    this.idMovie,
    this.quality,
    this.url,
    this.version,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return _$VersionFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VersionToJson(this);

  Version copyWith({
    AudioLanguage? audioLanguage,
    Codec? codec,
    String? comment,
    num? id,
    num? idMovie,
    Quality? quality,
    String? url,
    String? version,
  }) {
    return Version(
      audioLanguage: audioLanguage ?? this.audioLanguage,
      codec: codec ?? this.codec,
      comment: comment ?? this.comment,
      id: id ?? this.id,
      idMovie: idMovie ?? this.idMovie,
      quality: quality ?? this.quality,
      url: url ?? this.url,
      version: version ?? this.version,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      audioLanguage,
      codec,
      comment,
      id,
      idMovie,
      quality,
      url,
      version,
    ];
  }
}
