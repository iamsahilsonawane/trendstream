import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'network.g.dart';

@JsonSerializable()
class Network extends Equatable {
  final String? name;
  final int? id;
  @JsonKey(name: 'logo_path')
  final String? logoPath;
  @JsonKey(name: 'origin_country')
  final String? originCountry;

  const Network({this.name, this.id, this.logoPath, this.originCountry});

  factory Network.fromJson(Map<String, dynamic> json) {
    return _$NetworkFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NetworkToJson(this);

  Network copyWith({
    String? name,
    int? id,
    String? logoPath,
    String? originCountry,
  }) {
    return Network(
      name: name ?? this.name,
      id: id ?? this.id,
      logoPath: logoPath ?? this.logoPath,
      originCountry: originCountry ?? this.originCountry,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, id, logoPath, originCountry];
}
