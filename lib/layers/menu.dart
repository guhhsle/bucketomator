import 'package:flutter/material.dart';
import 'transfers.dart';
import '../template/widget/settings.dart';
import '../template/class/layer.dart';
import '../template/class/tile.dart';
import '../template/functions.dart';
import '../data.dart';

class MenuLayer extends Layer {
  @override
  void construct() {
    action = Tile('Settings', Icons.tune_rounded, '', () {
      goToPage(const PageSettings());
    });
    list = [
      Tile('Transfers', Icons.swap_horiz_rounded, '', () {
        Navigator.of(context).pop();
        TransfersLayer().show();
      }),
      Tile.fromPref(Pref.nodeSort),
      Tile.fromPref(Pref.showHidden),
      Tile.fromPref(Pref.prefixFirst),
    ];
  }
}
