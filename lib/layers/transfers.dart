import 'package:flutter/material.dart';
import '../services/transfers/manager.dart';
import '../template/layer.dart';
import '../template/tile.dart';

class TransfersLayer extends Layer {
  TransferManager get manager => TransferManager();

  @override
  void construct() {
    listenTo(manager);
    action = Tile('Transfers', Icons.swap_horiz_rounded);
    list = manager.transfers.map((t) => t.toTile).toList().reversed;
  }
}
