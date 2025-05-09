import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'group.dart';
import '../../template/functions.dart';
import '../../pages/group_node.dart';
import '../../template/tile.dart';

class BucketNode extends GroupNode {
  final Bucket bucket;
  BucketNode({required this.bucket, super.path = ''});

  @override
  String get name => bucket.name;

  @override
  Tile get toTile {
    return Tile.complex(name, Icons.folder_copy_rounded, '', () async {
      goToPage(GroupNodePage(groupNode: this));
    }, onHold: () {});
  }
}
