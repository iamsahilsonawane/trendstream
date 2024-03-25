import 'package:equatable/equatable.dart';

class Size extends Equatable {
  final int? id;
  final String? value;
  final bool? active;

  const Size({this.id, this.value, this.active});

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        id: json['id'] as int?,
        value: json['value'] as String?,
        active: json['active'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
        'active': active,
      };

  Size copyWith({
    int? id,
    String? value,
    bool? active,
  }) {
    return Size(
      id: id ?? this.id,
      value: value ?? this.value,
      active: active ?? this.active,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, value, active];
}
