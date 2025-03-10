import 'package:rapidgator/models/file_info.dart';

/// Represents a one-time download link.
class OneTimeLinkInfo {
  final String linkId;
  final FileInfo file;
  final String url;
  final int state;
  final String stateLabel;
  final String? callbackUrl;
  final bool notify;
  final DateTime created;
  final bool downloaded;

  OneTimeLinkInfo({
    required this.linkId,
    required this.file,
    required this.url,
    required this.state,
    required this.stateLabel,
    this.callbackUrl,
    required this.notify,
    required this.created,
    required this.downloaded,
  });

  /// Converts a JSON map into a [OneTimeLinkInfo] object.
  factory OneTimeLinkInfo.fromJson(Map<String, dynamic> json) {
    return OneTimeLinkInfo(
      linkId: json['link_id'],
      file: FileInfo.fromJson(json['file']),
      url: json['url'],
      state: json['state'],
      stateLabel: json['state_label'],
      callbackUrl: json['callback_url'],
      notify: json['notify'],
      created: DateTime.fromMillisecondsSinceEpoch(json['created'] * 1000),
      downloaded: json['downloaded'],
    );
  }
}
