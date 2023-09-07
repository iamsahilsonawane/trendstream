import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'codec.g.dart';

@JsonSerializable()
class Codec extends Equatable {
  final num? id;
  final String? name;

  const Codec({this.id, this.name});

  factory Codec.fromJson(Map<String, dynamic> json) => _$CodecFromJson(json);

  Map<String, dynamic> toJson() => _$CodecToJson(this);

  Codec copyWith({
    num? id,
    String? name,
  }) {
    return Codec(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
