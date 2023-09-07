import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'urls_image.dart';

part 'poster.g.dart';

@JsonSerializable()
class Poster extends Equatable {
  final bool? active;
  @JsonKey(name: 'aspect_ratio')
  final num? aspectRatio;
  @JsonKey(name: 'file_path')
  final String? filePath;
  final num? height;
  final num? id;
  @JsonKey(name: 'id_image')
  final num? idImage;
  @JsonKey(name: 'iso_639_1')
  final String? iso6391;
  final dynamic params;
  @JsonKey(name: 'suggested_name')
  final String? suggestedName;
  @JsonKey(name: 'urls_image')
  final List<UrlsImage>? urlsImage;
  @JsonKey(name: 'vote_average')
  final num? voteAverage;
  @JsonKey(name: 'vote_count')
  final num? voteCount;
  final num? width;

  const Poster({
    this.active,
    this.aspectRatio,
    this.filePath,
    this.height,
    this.id,
    this.idImage,
    this.iso6391,
    this.params,
    this.suggestedName,
    this.urlsImage,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  factory Poster.fromJson(Map<String, dynamic> json) {
    return _$PosterFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PosterToJson(this);

  Poster copyWith({
    bool? active,
    num? aspectRatio,
    String? filePath,
    num? height,
    num? id,
    num? idImage,
    String? iso6391,
    dynamic params,
    String? suggestedName,
    List<UrlsImage>? urlsImage,
    num? voteAverage,
    num? voteCount,
    num? width,
  }) {
    return Poster(
      active: active ?? this.active,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      filePath: filePath ?? this.filePath,
      height: height ?? this.height,
      id: id ?? this.id,
      idImage: idImage ?? this.idImage,
      iso6391: iso6391 ?? this.iso6391,
      params: params ?? this.params,
      suggestedName: suggestedName ?? this.suggestedName,
      urlsImage: urlsImage ?? this.urlsImage,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      width: width ?? this.width,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      active,
      aspectRatio,
      filePath,
      height,
      id,
      idImage,
      iso6391,
      params,
      suggestedName,
      urlsImage,
      voteAverage,
      voteCount,
      width,
    ];
  }
}
