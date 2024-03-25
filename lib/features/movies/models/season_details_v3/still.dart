import 'package:equatable/equatable.dart';

import 'urls_image.dart';

class Still extends Equatable {
  final int? id;
  final num? aspectRatio;
  final String? filePath;
  final num? height;
  final num? voteAverage;
  final num? voteCount;
  final num? width;
  final bool? active;
  final dynamic iso6391;
  final dynamic suggestedName;
  final int? idImage;
  final List<UrlsImage>? urlsImage;
  final dynamic params;

  const Still({
    this.id,
    this.aspectRatio,
    this.filePath,
    this.height,
    this.voteAverage,
    this.voteCount,
    this.width,
    this.active,
    this.iso6391,
    this.suggestedName,
    this.idImage,
    this.urlsImage,
    this.params,
  });

  factory Still.fromJson(Map<String, dynamic> json) => Still(
        id: json['id'] as int?,
        aspectRatio: json['aspect_ratio'] as num?,
        filePath: json['file_path'] as String?,
        height: json['height'] as num?,
        voteAverage: json['vote_average'] as num?,
        voteCount: json['vote_count'] as num?,
        width: json['width'] as num?,
        active: json['active'] as bool?,
        iso6391: json['iso_639_1'] as dynamic,
        suggestedName: json['suggested_name'] as dynamic,
        idImage: json['id_image'] as int?,
        urlsImage: (json['urls_image'] as List<dynamic>?)
            ?.map((e) => UrlsImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        params: json['params'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'aspect_ratio': aspectRatio,
        'file_path': filePath,
        'height': height,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'width': width,
        'active': active,
        'iso_639_1': iso6391,
        'suggested_name': suggestedName,
        'id_image': idImage,
        'urls_image': urlsImage?.map((e) => e.toJson()).toList(),
        'params': params?.toJson(),
      };

  Still copyWith({
    int? id,
    num? aspectRatio,
    String? filePath,
    num? height,
    num? voteAverage,
    num? voteCount,
    num? width,
    bool? active,
    dynamic iso6391,
    dynamic suggestedName,
    int? idImage,
    List<UrlsImage>? urlsImage,
    dynamic params,
  }) {
    return Still(
      id: id ?? this.id,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      filePath: filePath ?? this.filePath,
      height: height ?? this.height,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      width: width ?? this.width,
      active: active ?? this.active,
      iso6391: iso6391 ?? this.iso6391,
      suggestedName: suggestedName ?? this.suggestedName,
      idImage: idImage ?? this.idImage,
      urlsImage: urlsImage ?? this.urlsImage,
      params: params ?? this.params,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      aspectRatio,
      filePath,
      height,
      voteAverage,
      voteCount,
      width,
      active,
      iso6391,
      suggestedName,
      idImage,
      urlsImage,
      params,
    ];
  }
}
