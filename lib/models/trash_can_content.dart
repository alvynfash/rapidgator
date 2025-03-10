/// Represents content in the trash can.
class TrashCanContent {
  final String fileId;
  final int mode;
  final String modeLabel;
  final String? folderId;
  final String name;
  final String hash;
  final int size;
  final DateTime created;
  final String url;
  final int nbDownloads;

  TrashCanContent({
    required this.fileId,
    required this.mode,
    required this.modeLabel,
    this.folderId,
    required this.name,
    required this.hash,
    required this.size,
    required this.created,
    required this.url,
    required this.nbDownloads,
  });

  /// Converts a JSON map into a [TrashCanContent] object.
  factory TrashCanContent.fromJson(Map<String, dynamic> json) {
    return TrashCanContent(
      fileId: json['file_id'],
      mode: json['mode'],
      modeLabel: json['mode_label'],
      folderId: json['folder_id'],
      name: json['name'],
      hash: json['hash'],
      size: json['size'],
      created: DateTime.fromMillisecondsSinceEpoch(json['created'] * 1000),
      url: json['url'],
      nbDownloads: json['nb_downloads'],
    );
  }
}
