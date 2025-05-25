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
        Navigator.of(context).pop();
        final dest = await getInput(node.path, 'Move destination');
        await node.moveTo(dest).call();
      }),
      Tile('Copy', Icons.content_copy_rounded, '', () async {
        Navigator.of(context).pop();
        final dest = await getInput(node.path, 'Copy destination');
        await node.copyTo(dest).call();
      }),
      Tile('Sync & download', Icons.file_download_rounded, '', () {
        Navigator.of(context).pop();
        node.downloadRefreshed.call();
      }),
      Tile('Save as is', Icons.file_download_rounded, '', () {
        Navigator.of(context).pop();
        node.saveAsIs();
      }),
      Tile('${node.date?.toLocal()}', Icons.event_rounded),
      Tile('Size', Icons.memory_rounded, formatBytes(node.size)),
      Tile('Delete', Icons.delete_forever_rounded, '', () {
        Navigator.of(context).pop();
        node.tryRemove();
      }),
    ];
  }
}
