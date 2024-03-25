import 'package:equatable/equatable.dart';

class CodecV3 extends Equatable {
  final num? id;
  final String? name;

  const CodecV3({this.id, this.name});

  factory CodecV3.fromJson(Map<String, dynamic> json) => CodecV3(
        id: json['id'] as num?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  CodecV3 copyWith({
    num? id,
    String? name,
  }) {
    return CodecV3(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
