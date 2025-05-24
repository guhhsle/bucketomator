import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'subgroup.dart';
import 'blob.dart';
import '../../template/class/tile.dart';
import '../../layers/nodes/bucket.dart';
import '../transfer.dart';

class BucketNode extends SubGroupNode {
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
  Transfer get forceRemove {
    final collected = <BlobNode>[];
    final transfer = Transfer('Removing $name');

    transfer.future = () async {
      await addSubBlobNodesTo(collected).copyWith(parent: transfer).call();
      await removeNodes(collected).copyWith(parent: transfer).call();
      await storage.removeBucket(this);
      await root.remotelyRefresh();
    }.call();
    return transfer;
  }
}
