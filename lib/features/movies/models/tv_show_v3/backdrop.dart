import 'package:equatable/equatable.dart';

import 'params.dart';
import 'urls_image.dart';

class Backdrop extends Equatable {
  final bool? active;
  final num? aspectRatio;
  final String? filePath;
  final num? height;
  final num? id;
  final num? idImage;
  final String? iso6391;
  final Params? params;
  final String? suggestedName;
  final List<UrlsImage>? urlsImage;
  final num? voteAverage;
  final num? voteCount;
  final num? width;

  const Backdrop({
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

  factory Backdrop.fromJson(Map<String, dynamic> json) => Backdrop(
        active: json['active'] as bool?,
        aspectRatio: json['aspect_ratio'] as num?,
        filePath: json['file_path'] as String?,
        height: json['height'] as num?,
        id: json['id'] as num?,
        idImage: json['id_image'] as num?,
        iso6391: json['iso_639_1'] as String?,
        params: json['params'] == null
            ? null
            : Params.fromJson(json['params'] as Map<String, dynamic>),
        suggestedName: json['suggested_name'] as String?,
        urlsImage: (json['urls_image'] as List<dynamic>?)
            ?.map((e) => UrlsImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        voteAverage: json['vote_average'] as num?,
        voteCount: json['vote_count'] as num?,
        width: json['width'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'active': active,
        'aspect_ratio': aspectRatio,
        'file_path': filePath,
        'height': height,
        'id': id,
        'id_image': idImage,
        'iso_639_1': iso6391,
        'params': params?.toJson(),
        'suggested_name': suggestedName,
        'urls_image': urlsImage?.map((e) => e.toJson()).toList(),
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'width': width,
      };

  Backdrop copyWith({
    bool? active,
    num? aspectRatio,
    String? filePath,
    num? height,
    num? id,
    num? idImage,
    String? iso6391,
    Params? params,
    String? suggestedName,
    List<UrlsImage>? urlsImage,
    num? voteAverage,
    num? voteCount,
    num? width,
  }) {
    return Backdrop(
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
