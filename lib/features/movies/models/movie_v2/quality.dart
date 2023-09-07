import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quality.g.dart';

@JsonSerializable()
class Quality extends Equatable {
  final num? id;
  final String? name;

  const Quality({this.id, this.name});

  factory Quality.fromJson(Map<String, dynamic> json) {
    return _$QualityFromJson(json);
  }

  Map<String, dynamic> toJson() => _$QualityToJson(this);

  Quality copyWith({
    num? id,
    String? name,
  }) {
    return Quality(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
