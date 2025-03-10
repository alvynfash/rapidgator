/// Represents user information returned by the RapidGator API.
class UserInfo {
  final String email;
  final bool isPremium;
  final DateTime? premiumEndTime;
  final int state;
  final String stateLabel;
  final TrafficInfo traffic;
  final StorageInfo storage;
  final UploadInfo upload;
  final RemoteUploadInfo remoteUpload;

  UserInfo({
    required this.email,
    required this.isPremium,
    this.premiumEndTime,
    required this.state,
    required this.stateLabel,
    required this.traffic,
    required this.storage,
    required this.upload,
    required this.remoteUpload,
  });

  /// Converts a JSON map into a [UserInfo] object.
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      isPremium: json['is_premium'],
      premiumEndTime: json['premium_end_time'] != null
          ? DateTime.parse(json['premium_end_time'])
          : null,
      state: json['state'],
      stateLabel: json['state_label'],
      traffic: TrafficInfo.fromJson(json['traffic']),
      storage: StorageInfo.fromJson(json['storage']),
      upload: UploadInfo.fromJson(json['upload']),
      remoteUpload: RemoteUploadInfo.fromJson(json['remote_upload']),
    );
  }
}

/// Represents traffic information for the user.
class TrafficInfo {
  final int? total;
  final int? left;

  TrafficInfo({this.total, this.left});

  /// Converts a JSON map into a [TrafficInfo] object.
  factory TrafficInfo.fromJson(Map<String, dynamic> json) {
    return TrafficInfo(
      total: json['total'],
      left: json['left'],
    );
  }
}

/// Represents storage information for the user.
class StorageInfo {
  final int total;
  final int left;

  StorageInfo({required this.total, required this.left});

  /// Converts a JSON map into a [StorageInfo] object.
  factory StorageInfo.fromJson(Map<String, dynamic> json) {
    return StorageInfo(
      total: json['total'],
      left: json['left'],
    );
  }
}

/// Represents upload information for the user.
class UploadInfo {
  final int maxFileSize;
  final int nbPipes;

  UploadInfo({required this.maxFileSize, required this.nbPipes});

  /// Converts a JSON map into an [UploadInfo] object.
  factory UploadInfo.fromJson(Map<String, dynamic> json) {
    return UploadInfo(
      maxFileSize: json['max_file_size'],
      nbPipes: json['nb_pipes'],
    );
  }
}

/// Represents remote upload information for the user.
class RemoteUploadInfo {
  final int maxNbJobs;
  final int refreshTime;

  RemoteUploadInfo({required this.maxNbJobs, required this.refreshTime});

  /// Converts a JSON map into a [RemoteUploadInfo] object.
  factory RemoteUploadInfo.fromJson(Map<String, dynamic> json) {
    return RemoteUploadInfo(
      maxNbJobs: json['max_nb_jobs'],
      refreshTime: json['refresh_time'],
    );
  }
}
