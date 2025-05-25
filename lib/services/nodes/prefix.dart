import 'package:flutter/material.dart';
import 'subgroup.dart';
import 'blob.dart';
import '../../template/class/tile.dart';
import '../../layers/nodes/prefix.dart';
import '../../template/functions.dart';
import '../transfer.dart';

class PrefixNode extends SubGroupNode {
  PrefixNode({required super.parent, required super.path, super.fsEntity});

  @override
  Tile get toTile => Tile.complex(
    displayName,
    Icons.folder_rounded,
    '',
    open,
    onHold: () => PrefixNodeLayer(node: this).show(),
  );

  @override
  void tryRemove() => showSnack(
    'Press to remove $name',
    false,
    onTap: () => forceRemove.call(),
  );

  @override
  Transfer get forceRemove {
    final collected = <BlobNode>[];
    final transfer = Transfer('Removing $name');

    transfer.future = () async {
      await addSubBlobNodesTo(collected).copyWith(parent: transfer).call();
      await removeNodes(collected).copyWith(parent: transfer).call();
      await parent?.remotelyRefresh();
    }.call();
    return transfer;
  }

  Transfer copyTo(String dest) {
    if (!dest.endsWith('/')) {
      showSnack('Must end with /', false);
      throw Error();
    }
    final transfer = Transfer('Copying $name to $dest');

    transfer.future = () async {
      final collected = <BlobNode>[];
      await addSubBlobNodesTo(collected).copyWith(parent: transfer).call();
      final transfers = <Transfer>[];

      for (int i = 0; i < collected.length; i++) {
        final blobNode = collected[i];
        final newBlobDest = blobNode.path.replaceFirst(path, dest);
        transfers.add(blobNode.copyTo(newBlobDest).copyWith(parent: transfer));
      }
      await Future.wait(transfers.map((t) => t.call()));
      await parent?.remotelyRefresh();
    }.call();

    return transfer;
  }

  Transfer moveTo(String dest) {
    final transfer = Transfer('Moving $name to $dest');
    transfer.future = () async {
      await copyTo(dest).copyWith(parent: transfer).call();
      await forceRemove.copyWith(parent: transfer).call();
    }.call();
    return transfer;
  }
}
