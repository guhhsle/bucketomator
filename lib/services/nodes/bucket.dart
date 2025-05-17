import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'group.dart';
import 'root.dart';
import '../../layers/nodes/bucket.dart';
import '../../template/functions.dart';
import '../../pages/nodes/group.dart';
import '../transfers/transfer.dart';
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
  Transfer get forceRemove => Transfer(
    'Removing $name',
    future: () async {
      await EndPoint().removeBucket(this);
      await RootNode().refresh();
    }.call(),
  );
}
