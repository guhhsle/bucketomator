import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'group.dart';
import '../../template/class/tile.dart';
import '../../layers/nodes/bucket.dart';
import '../transfers/transfer.dart';

class BucketNode extends GroupNode {
  final Bucket literalBucket; //Could've just been a String for bucket name
  BucketNode({
    required this.literalBucket,
    required super.parent,
    super.path = '',
    super.fsEntity,
  });

  @override
  String get name => literalBucket.name;

  @override
  Tile get toTile => Tile.complex(
    displayName,
    Icons.folder_copy_rounded,
    '',
    open,
    onHold: () => BucketNodeLayer(node: this).show(),
  );

  @override
  Transfer get forceRemove => Transfer(
    'Removing $name',
    future: () async {
      await storage.removeBucket(this);
      await root.remotelyRefresh();
    }.call(),
  );
}
