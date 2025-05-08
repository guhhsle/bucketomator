String formatPath(String fullPath) {
  for (int i = fullPath.length - 1; i > 0; i--) {
    if (fullPath[i] == '/') return fullPath.substring(++i);
  }
  return fullPath;
}

String fileExtension(String fullPath) {
  for (int i = fullPath.length - 1; i > 0; i--) {
    if (fullPath[i] == '.') return fullPath.substring(++i);
  }
  return fullPath;
}
