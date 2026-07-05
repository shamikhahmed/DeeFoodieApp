import 'package:flutter/foundation.dart';

/// Strip GitHub Pages base prefix so GoRouter sees `/` not `/DeeFoodieApp/`.
String normalizeAppPath(String rawPath) {
  var path = rawPath;
  const prefixes = ['/DeeFoodieApp', '/deefoodieapp'];
  for (final prefix in prefixes) {
    if (path.startsWith(prefix)) {
      path = path.substring(prefix.length);
      break;
    }
  }
  if (path.isEmpty || path == '/') return '/';
  if (!path.startsWith('/')) path = '/$path';
  if (path.length > 1 && path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }
  return path;
}

String currentWebPath() {
  if (!kIsWeb) return '/';
  return normalizeAppPath(Uri.base.path);
}

bool isOnboardingPath(String path) => normalizeAppPath(path) == '/onboarding';
