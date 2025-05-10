import 'package:flutter/material.dart';
import 'package:s3/template/functions.dart';

import '../template/layer.dart';
import '../template/settings.dart';
import '../template/tile.dart';

class MenuLayer extends Layer {
  @override
  void construct() {
    action = Tile('Settings', Icons.tune_rounded, '', () {
      goToPage(const PageSettings());
    });
  }
}
