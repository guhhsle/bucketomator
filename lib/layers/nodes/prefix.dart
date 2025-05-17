// ignore_for_file: use_build_context_synchronously
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
        final dest = await getInput(node.path, 'Destination, end with /');
        await node.copyTo(dest).call();
        Navigator.of(context).pop();
      }),
      Tile('Move', Icons.drive_file_move_rounded, '', () async {
        final dest = await getInput(node.path, 'Destination, end with /');
        await node.moveTo(dest).call();
        Navigator.of(context).pop();
      }),
      Tile('Remove', Icons.delete_forever_rounded, '', node.tryRemove),
    ];
  }
}
