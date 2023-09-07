import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'size.g.dart';

@JsonSerializable()
class Size extends Equatable {
  final bool? active;
  final num? id;
  final String? value;

  const Size({this.active, this.id, this.value});

  factory Size.fromJson(Map<String, dynamic> json) => _$SizeFromJson(json);

  Map<String, dynamic> toJson() => _$SizeToJson(this);

  Size copyWith({
    bool? active,
    num? id,
    String? value,
  }) {
    return Size(
      active: active ?? this.active,
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [active, id, value];
}
