import 'package:flutter/material.dart';
import '../../services/nodes/prefix.dart';
import '../../template/class/layer.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';

class PrefixNodeLayer extends Layer {
  PrefixNode node;

  PrefixNodeLayer({required this.node});

  @override
  void construct() {
    action = Tile(node.name, Icons.folder_rounded);
    list = [
      Tile('Copy', Icons.folder_copy_rounded, '', () async {
        Navigator.of(context).pop();
        String dest = await getInput(node.path, 'Copy destination');
        if (!dest.endsWith('/')) dest += '/';
        await node.copyTo(dest).call();
      }),
      Tile('Move', Icons.drive_file_move_rounded, '', () async {
        Navigator.of(context).pop();
        String dest = await getInput(node.path, 'Move destination');
        if (!dest.endsWith('/')) dest += '/';
        await node.moveTo(dest).call();
      }),
      Tile('Delete', Icons.delete_forever_rounded, '', () {
        Navigator.of(context).pop();
        node.tryRemove();
      }),
    ];
  }
}
