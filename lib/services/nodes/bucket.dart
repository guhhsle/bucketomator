import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'group.dart';
import '../../layers/nodes/bucket.dart';
import '../../template/functions.dart';
import '../../pages/group_node.dart';
import '../../template/tile.dart';
import '../endpoint.dart';

class BucketNode extends GroupNode {
  final Bucket bucket;
  BucketNode({required this.bucket, super.path = ''});

  @override
  String get name => bucket.name;

  @override
  Tile get toTile {
    return Tile.complex(
      displayName,
      Icons.folder_copy_rounded,
      '',
      () => goToPage(GroupNodePage(groupNode: this)),
      onHold: () => BucketNodeLayer(node: this).show(),
    );
  }

  @override
  Future<void> forceRemove() async {
    await EndPoint().removeBucket(this);
  }

  @override
  void tryRemove() {
    showSnack(
      'Press to remove $name',
      false,
      onTap: () async {
        await forceRemove();
        showSnack('Removed $name', false);
      },
    );
  }
}
