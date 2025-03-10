/// Represents folder information returned by the RapidGator API.
class FolderInfo {
  final String folderId;
  final int mode;
  final String modeLabel;
  final String? parentFolderId;
  final String name;
  final String url;
  final int nbFolders;
  final int nbFiles;
  final int? sizeFiles;
  final DateTime created;
  final List<FolderInfo> folders;

  FolderInfo({
    required this.folderId,
    required this.mode,
    required this.modeLabel,
    this.parentFolderId,
    required this.name,
    required this.url,
    required this.nbFolders,
    required this.nbFiles,
    this.sizeFiles,
    required this.created,
    required this.folders,
  });

  /// Converts a JSON map into a [FolderInfo] object.
  factory FolderInfo.fromJson(Map<String, dynamic> json) {
    return FolderInfo(
      folderId: json['folder_id'],
      mode: json['mode'],
      modeLabel: json['mode_label'],
      parentFolderId: json['parent_folder_id'],
      name: json['name'],
      url: json['url'],
      nbFolders: int.parse(json['nb_folders'].toString()),
      nbFiles: int.parse(json['nb_files'].toString()),
      sizeFiles: json['size_files'],
      created: DateTime.parse(json['created_at']),
      folders: (json['folders'] as List)
          .map((item) => FolderInfo.fromJson(item))
          .toList(),
    );
  }
}
