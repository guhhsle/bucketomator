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
