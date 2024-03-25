import 'package:equatable/equatable.dart';

class Quality extends Equatable {
  final num? id;
  final String? name;

  const Quality({this.id, this.name});

  factory Quality.fromJson(Map<String, dynamic> json) => Quality(
        id: json['id'] as num?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

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
