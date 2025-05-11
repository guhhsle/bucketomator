String nameFromPath(String path) {
  if (path[path.length - 1] == '/') path = path.substring(0, path.length - 1);
  for (int i = path.length - 1; i > 0; i--) {
    if (path[i] == '/') return path.substring(++i);
  }
  return path;
}

String extensionFromPath(String path) {
  for (int i = path.length - 1; i > 0; i--) {
    if (path[i] == '.') return path.substring(++i);
  }
  return path;
}

String renamePath(String path, String newName) {
  for (int i = path.length - 1; i > 0; i--) {
    if (path[i] == '/') return path.substring(0, ++i) + newName;
  }
  return newName;
}

String formatBytes(int? bytes, {int decimals = 1}) {
  if (bytes == null) return '?';
  if (bytes <= 0) return '0 B';

  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  var i = 0;
  double size = bytes.toDouble();

  while (size >= 1024 && i < suffixes.length - 1) {
    size /= 1024;
    i++;
  }

  return '${size.toStringAsFixed(i > 0 ? decimals : 0)} ${suffixes[i]}';
}

String capitalize(String text) {
  if (text.isEmpty) return '';

  if (text.length == 1) return text.toUpperCase();

  return text[0].toUpperCase() + text.substring(1);
}
