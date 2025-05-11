import 'package:flutter/material.dart';
import '../../services/nodes/bucket.dart';
import '../../template/layer.dart';
import '../../template/tile.dart';

class BucketNodeLayer extends Layer {
  BucketNode node;

  BucketNodeLayer({required this.node});

  @override
  void construct() {
    action = Tile(node.name, Icons.folder_copy_rounded);
    list = [Tile('Remove', Icons.delete_forever_rounded, '', node.tryRemove)];
  }
}
