/// Represents the response for checking a download link.
class CheckLinkResponse {
  final String url;
  final String? filename;
  final int? size;
  final String status;

  CheckLinkResponse({
    required this.url,
    this.filename,
    this.size,
    required this.status,
  });

  /// Converts a JSON map into a [CheckLinkResponse] object.
  factory CheckLinkResponse.fromJson(Map<String, dynamic> json) {
    return CheckLinkResponse(
      url: json['url'],
      filename: json['filename'],
      size: json['size'],
      status: json['status'],
    );
  }
}
