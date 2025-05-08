import 'package:flutter/material.dart';

import '../functions.dart';
import '../template/tile.dart';

abstract class StorageItem with ChangeNotifier {
  String get name => formatPath(path);
  String get path;

  Future<void> refresh();
  Tile get toTile => Tile();
  Widget get toWidget => toTile.toWidget;
}
