import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latest_movies/features/movies/models/movie_video/movie_video.dart';

part 'videos_result.g.dart';

@JsonSerializable()
class VideosResult extends Equatable {
  @JsonKey(name: 'results')
  final List<MovieVideo>? results;

  const VideosResult({
    this.results,
  });

  factory VideosResult.fromJson(Map<String, dynamic> json) =>
      _$VideosResultFromJson(json);

  Map<String, dynamic> toJson() => _$VideosResultToJson(this);

  @override
  List<Object?> get props => [results];

  VideosResult copyWith({
    List<MovieVideo>? results,
  }) {
    return VideosResult(
      results: results ?? this.results,
    );
  }

  @override
  bool get stringify => true;
}
