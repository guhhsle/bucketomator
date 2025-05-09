import 'package:flutter/material.dart';
import '../endpoint.dart';
import 'blob.dart';
import 'group.dart';
import '../../layers/nodes/prefix.dart';
import '../../template/functions.dart';
import '../../pages/group_node.dart';
import '../../template/tile.dart';

class PrefixNode extends GroupNode {
  DateTime? date;

  PrefixNode({required super.parent, required super.path});

  @override
  Tile get toTile {
    return Tile.complex(name, Icons.folder_rounded, '', () async {
      goToPage(GroupNodePage(groupNode: this));
    }, onHold: () => PrefixNodeLayer(node: this).show());
  }

  Future<void> remove() async {
    final subBlobNodes = <BlobNode>[];
    await addSubBlobNodesTo(subBlobNodes);
    await EndPoint().removeBlobNodes(subBlobNodes);
    refreshToRoot();
  }

  Future<List<BlobNode>> addSubBlobNodesTo(
    List<BlobNode> collected, {
    bool showAlert = true,
  }) async {
    await refresh();
    if (showAlert) showSnack('Removing $path', false);
    collected.addAll(blobs);
    List<Future> futures = [];
    for (final group in groups) {
      group as PrefixNode;
      futures.add(group.addSubBlobNodesTo(collected));
    }
    await Future.wait(futures);
    return collected;
  }
}
