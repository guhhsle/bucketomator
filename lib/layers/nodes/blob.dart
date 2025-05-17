// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../../template/class/layer.dart';
import '../../services/nodes/blob.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';
import '../../functions.dart';

class BlobNodeLayer extends Layer {
  BlobNode node;
  BlobNodeLayer({required this.node});

  @override
  void construct() {
    action = Tile(node.name, Icons.description_rounded);

    list = [
      Tile('Move', Icons.drive_file_move, '', () async {
        final dest = await getInput(node.path, 'Destination');
        await node.moveTo(dest).call();
        Navigator.of(context).pop();
      }),
      Tile('Copy', Icons.content_copy_rounded, '', () async {
        final dest = await getInput(node.path, 'Destination');
        await node.copyTo(dest).call();
        Navigator.of(context).pop();
      }),
      Tile('Download', Icons.file_download_rounded, '', () {
        node.download.call();
      }),
      Tile('${node.date?.toLocal()}', Icons.event_rounded),
      Tile('Size', Icons.memory_rounded, formatBytes(node.size)),
      Tile('Remove', Icons.delete_forever_rounded, '', node.tryRemove),
    ];
  }
}
