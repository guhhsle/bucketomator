import 'package:flutter/material.dart';
import '../../services/nodes/bucket.dart';
import '../../template/class/layer.dart';
import '../../template/class/tile.dart';

class BucketNodeLayer extends Layer {
  BucketNode node;

  BucketNodeLayer({required this.node});

  @override
  void construct() {
    action = Tile(node.name, Icons.folder_copy_rounded);
    list = [Tile('Delete', Icons.delete_forever_rounded, '', node.tryRemove)];
  }
}
