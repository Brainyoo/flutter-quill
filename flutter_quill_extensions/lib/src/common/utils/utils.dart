import 'patterns.dart';

bool isBase64(String str) {
  return base64RegExp.hasMatch(str);
}

bool isHttpUrl(String url) {
  try {
    final uri = Uri.parse(url.trim());
    return uri.isScheme('HTTP') || uri.isScheme('HTTPS');
  } catch (_) {
    return false;
  }
}

bool isImageBase64(String imageUrl) {
  return !isHttpUrl(imageUrl) && isBase64(imageUrl);
}
