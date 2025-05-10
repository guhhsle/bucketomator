import 'package:flutter/material.dart';
import '../endpoint.dart';
import 'blob.dart';
import 'group.dart';
import '../../layers/nodes/prefix.dart';
import '../../template/functions.dart';
import '../../pages/group_node.dart';
import '../../template/tile.dart';

class PrefixNode extends GroupNode {
  PrefixNode({required super.parent, required super.path});

  @override
  Tile get toTile {
    return Tile.complex(name, Icons.folder_rounded, '', () async {
      goToPage(GroupNodePage(groupNode: this));
    }, onHold: () => PrefixNodeLayer(node: this).show());
  }

  void tryRemove() {
    showSnack(
      'Press to confirm',
      false,
      onTap: () async {
        await forceRemove();
        showSnack('Removed $name', false);
      },
    );
  }

  Future<void> forceRemove() async {
    final subBlobNodes = <BlobNode>[];
    await addSubBlobNodesTo(subBlobNodes);
    await EndPoint().removeBlobNodes(subBlobNodes);
    refreshToRoot();
  }

  Future<void> copyTo(String dest, {bool alert = true}) async {
    if (!dest.endsWith('/')) {
      showSnack('Must end with /', false);
      throw Error();
    }
    final subBlobNodes = <BlobNode>[];
    await addSubBlobNodesTo(subBlobNodes);
    final length = subBlobNodes.length;
    for (int i = 0; i < length; i++) {
      final blobNode = subBlobNodes[i];
      showSnack('${i + 1}/$length ${blobNode.name}', true);
      final newBlobDest = blobNode.path.replaceFirst(path, dest);
      try {
        await EndPoint().copyBlobNode(blobNode, newBlobDest);
      } catch (e) {
        showSnack('Error when copying ${blobNode.name} $e', false);
      }
    }
    if (alert) showSnack('Done', true);
    parent!.refresh();
  }

  Future<void> moveTo(String dest) async {
    await copyTo(dest, alert: false);
    await forceRemove();
    showSnack('Done', true);
  }
}
