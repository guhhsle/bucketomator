import 'package:flutter/material.dart';
import '../../services/storage/storage.dart';
import '../../template/class/layer.dart';
import '../../template/class/tile.dart';
import '../../services/nodes/sub.dart';

class CachedNodeLayer extends Layer {
  SubNode node;
  CachedNodeLayer({required this.node});
  @override
  void construct() {
    action = Tile(node.name, Icons.description_rounded);
    list = [
      Tile('Uncache', Icons.delete_forever_rounded, '', () async {
        await node.fsEntity?.delete(recursive: true);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        Storage().root.refreshCachedNodes();
      }),
    ];
  }
}
