import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'icon.g.dart';

@JsonSerializable()
class Icon extends Equatable {
  final String? src;

  const Icon({this.src});

  factory Icon.fromJson(Map<String, dynamic> json) => _$IconFromJson(json);

  Map<String, dynamic> toJson() => _$IconToJson(this);

  Icon copyWith({
    String? src,
  }) {
    return Icon(
      src: src ?? this.src,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [src];
}
