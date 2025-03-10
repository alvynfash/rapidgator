/// Extracts the fileId from a Rapidgator file URL.
///
/// Throws an [RapidgatorException] if the URL is invalid.
String getFileIdFromUrl(String url) {
  // Normalize the URL by removing query parameters and trailing slashes
  final normalizedUrl =
      url.split('?').first.replaceAll('/', ' ').trim().replaceAll(' ', '/');

  // Define known Rapidgator URL patterns
  const rapidgatorFileUrlPatterns = [
    'https://rapidgator.net/file/',
    'https://rg.to/file/',
  ];

  // Check if the URL matches any known pattern
  String? baseUrl;
  for (final pattern in rapidgatorFileUrlPatterns) {
    if (normalizedUrl.startsWith(pattern)) {
      baseUrl = pattern;
      break;
    }
  }

  if (baseUrl == null) {
    throw Exception('Invalid Rapidgator file URL.');
  }

  // Remove the base URL to isolate the fileId and filename
  final parts = normalizedUrl.substring(baseUrl.length).split('/');

  // The first part should be the fileId
  if (parts.isEmpty) {
    throw Exception('No fileId found in the URL.');
  }

  return parts[0];
}
