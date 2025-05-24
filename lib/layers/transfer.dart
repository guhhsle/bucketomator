import 'package:flutter/material.dart';
import '../template/class/layer.dart';
import '../template/class/tile.dart';
import '../services/transfer.dart';

class TransferLayer extends Layer {
  Transfer? root;

  TransferLayer({this.root});
  @override
  bool get scroll => true; //Multiline bricks

  Iterable<Transfer> get subTransfers =>
      Transfer.all.value.where((t) => t.parent == root);

  @override
  void construct() {
    listenTo(Transfer.all);
    if (root == null) {
      action = Tile('Transfers', Icons.swap_horiz_rounded);
    } else {
      action = Tile(root!.errorMessage ?? root!.status, root!.icon);
    }
    list = subTransfers.map((t) => t.toTile).toList().reversed;
  }
}
