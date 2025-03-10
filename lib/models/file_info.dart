/// Represents file information returned by the RapidGator API.
class FileInfo {
  final String fileId;
  final int mode;
  final String modeLabel;
  final String? folderId;
  final String name;
  final String hash;
  final int size;
  final DateTime created;
  final String url;

  FileInfo({
    required this.fileId,
    required this.mode,
    required this.modeLabel,
    this.folderId,
    required this.name,
    required this.hash,
    required this.size,
    required this.created,
    required this.url,
  });

  /// Converts a JSON map into a [FileInfo] object.
  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      fileId: json['file_id'],
      mode: json['mode'],
      modeLabel: json['mode_label'],
      folderId: json['folder_id'],
      name: json['name'],
      hash: json['hash'],
      size: json['size'],
      created: DateTime.parse(json['created_at']),
      url: json['url'],
    );
  }
}
