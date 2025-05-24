import 'package:flutter/material.dart';
import 'transfer.dart';
import '../services/storage/substorage.dart';
import '../template/widget/settings.dart';
import '../layers/nodes/all_cached.dart';
import '../template/class/layer.dart';
import '../template/class/tile.dart';
import '../template/functions.dart';
import '../data.dart';

class MenuLayer extends Layer {
  SubStorage storage;

  MenuLayer({required this.storage});
  @override
  void construct() {
    action = Tile('Settings', Icons.tune_rounded, '', () {
      goToPage(const PageSettings());
    });
    list = [
      Tile('Transfers', Icons.swap_horiz_rounded, '', () {
        Navigator.of(context).pop();
        TransferLayer().show();
      }),
      Tile('Cache', Icons.memory_rounded, '', () {
        Navigator.of(context).pop();
        AllCachedNodesLayer(storage: storage).show();
      }),
      Tile.fromPref(Pref.nodeSort),
      Tile.fromPref(Pref.showHidden),
      Tile.fromPref(Pref.prefixFirst),
    ];
  }
}
