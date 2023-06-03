import 'package:equatable/equatable.dart';

class LiveChannel extends Equatable {
  final String? id;
  final String? channelName;
  final String? channelBanner;

  const LiveChannel({this.id, this.channelName, this.channelBanner});

  factory LiveChannel.fromJson(Map<String, dynamic> json) => LiveChannel(
        id: json['id'] as String?,
        channelName: json['channel_name'] as String?,
        channelBanner: json['channel_banner'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'channel_name': channelName,
        'channel_banner': channelBanner,
      };

  LiveChannel copyWith({
    String? id,
    String? channelName,
    String? channelBanner,
  }) {
    return LiveChannel(
      id: id ?? this.id,
      channelName: channelName ?? this.channelName,
      channelBanner: channelBanner ?? this.channelBanner,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, channelName, channelBanner];
}
