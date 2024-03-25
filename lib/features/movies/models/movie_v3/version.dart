import 'package:equatable/equatable.dart';

import 'audio_language.dart';
import 'codec.dart';
import 'quality.dart';

class VersionV3 extends Equatable {
  final AudioLanguage? audioLanguage;
  final CodecV3? codec;
  final String? comment;
  final num? id;
  final num? idMovie;
  final Quality? quality;
  final String? url;
  final String? version;

  const VersionV3({
    this.audioLanguage,
    this.codec,
    this.comment,
    this.id,
    this.idMovie,
    this.quality,
    this.url,
    this.version,
  });

  factory VersionV3.fromJson(Map<String, dynamic> json) => VersionV3(
        audioLanguage: json['audioLanguage'] == null
            ? null
            : AudioLanguage.fromJson(
                json['audioLanguage'] as Map<String, dynamic>),
        codec: json['codec'] == null
            ? null
            : CodecV3.fromJson(json['codec'] as Map<String, dynamic>),
        comment: json['comment'] as String?,
        id: json['id'] as num?,
        idMovie: json['id_movie'] as num?,
        quality: json['quality'] == null
            ? null
            : Quality.fromJson(json['quality'] as Map<String, dynamic>),
        url: json['url'] as String?,
        version: json['version'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'audioLanguage': audioLanguage?.toJson(),
        'codec': codec?.toJson(),
        'comment': comment,
        'id': id,
        'id_movie': idMovie,
        'quality': quality?.toJson(),
        'url': url,
        'version': version,
      };

  VersionV3 copyWith({
    AudioLanguage? audioLanguage,
    CodecV3? codec,
    String? comment,
    num? id,
    num? idMovie,
    Quality? quality,
    String? url,
    String? version,
  }) {
    return VersionV3(
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
