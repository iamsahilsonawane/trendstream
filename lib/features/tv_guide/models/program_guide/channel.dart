import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'channel.g.dart';

@JsonSerializable()
class Channel extends Equatable {
  final String? id;
  final String? name;
  final String? site;
  @JsonKey(name: 'site_id')
  final String? siteId;
  final String? lang;
  final String? logo;
  final String? url;

  const Channel({
    this.id,
    this.name,
    this.site,
    this.siteId,
    this.lang,
    this.logo,
    this.url,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return _$ChannelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChannelToJson(this);

  Channel copyWith({
    String? id,
    String? name,
    String? site,
    String? siteId,
    String? lang,
    String? logo,
    String? url,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      site: site ?? this.site,
      siteId: siteId ?? this.siteId,
      lang: lang ?? this.lang,
      logo: logo ?? this.logo,
      url: url ?? this.url,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, site, siteId, lang, logo, url];
}
