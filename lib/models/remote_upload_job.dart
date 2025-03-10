import 'package:rapidgator/models/file_info.dart';

/// Represents a remote upload job.
class RemoteUploadJob {
  final int jobId;
  final int type;
  final String typeLabel;
  final String folderId;
  final String url;
  final String? name;
  final int size;
  final int state;
  final String stateLabel;
  final FileInfo? file;
  final int dlSize;
  final int speed;
  final DateTime created;
  final DateTime? updated;
  final String? error;

  RemoteUploadJob({
    required this.jobId,
    required this.type,
    required this.typeLabel,
    required this.folderId,
    required this.url,
    this.name,
    required this.size,
    required this.state,
    required this.stateLabel,
    this.file,
    required this.dlSize,
    required this.speed,
    required this.created,
    this.updated,
    this.error,
  });

  /// Converts a JSON map into a [RemoteUploadJob] object.
  factory RemoteUploadJob.fromJson(Map<String, dynamic> json) {
    return RemoteUploadJob(
      jobId: json['job_id'],
      type: json['type'],
      typeLabel: json['type_label'],
      folderId: json['folder_id'],
      url: json['url'],
      name: json['name'],
      size: json['size'],
      state: json['state'],
      stateLabel: json['state_label'],
      file: json['file'] != null ? FileInfo.fromJson(json['file']) : null,
      dlSize: json['dl_size'],
      speed: json['speed'],
      created: DateTime.fromMillisecondsSinceEpoch(json['created'] * 1000),
      updated: json['updated'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updated'] * 1000)
          : null,
      error: json['error'],
    );
  }
}
