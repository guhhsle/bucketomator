import 'package:flutter/material.dart';
import '../../services/nodes/blob.dart';
import '../../template/functions.dart';
import '../../template/layer.dart';
import '../../template/tile.dart';

class BlobNodeLayer extends Layer {
  BlobNode node;

  BlobNodeLayer({required this.node});

  @override
  void construct() {
    action = Tile(node.name, Icons.drive_file_move, '', () async {
      final dest = await getInput(node.path, 'Destination');
      node.moveTo(dest);
    });

    list = [
      Tile('Remove', Icons.delete_forever_rounded, '', node.remove),
      Tile('Copy', Icons.content_copy_rounded, '', () async {
        final dest = await getInput(node.path, 'Destination');
        node.copyTo(dest);
      }),
      Tile('${node.date?.toLocal()}', Icons.event_rounded),
    ];
  }
}
