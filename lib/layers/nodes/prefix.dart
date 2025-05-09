import 'package:flutter/material.dart';
import '../../services/nodes/prefix.dart';
import '../../template/layer.dart';
import '../../template/tile.dart';

class PrefixNodeLayer extends Layer {
  PrefixNode node;

  PrefixNodeLayer({required this.node});

  @override
  void construct() {
    list = [
      Tile('Remove', Icons.delete_forever_rounded, '', node.remove),
      Tile('${node.date?.toLocal()}', Icons.event_rounded),
    ];
  }
}
