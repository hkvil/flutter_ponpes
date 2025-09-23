/// Utility functions for handling API URLs
class ApiUrlUtils {
  /// Build media URL from base host and image path
  ///
  /// Example:
  /// - baseHost: 'http://localhost:1337', path: '/uploads/image.jpg'
  /// - Result: 'http://localhost:1337/uploads/image.jpg'
  static String buildImageUrl(String baseHost, String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // If image path is already a full URL, return as is
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // Remove leading slash from image path if present
    String cleanImagePath = imagePath;
    if (cleanImagePath.startsWith('/')) {
      cleanImagePath = cleanImagePath.substring(1);
    }

    // Ensure only one slash between baseHost and path
    if (baseHost.endsWith('/')) {
      return baseHost + cleanImagePath;
    } else {
      return '$baseHost/$cleanImagePath';
    }
  }
}
