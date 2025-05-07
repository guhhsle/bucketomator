import 'package:flutter/material.dart';
import 'package:minio/models.dart';

import '../template/tile.dart';

class Sbucket {
  String? name, id;
  Sbucket({this.id, this.name});

  static Sbucket fromBucket(Bucket bucket) => Sbucket(name: bucket.name);

  Tile get toTile => Tile(name, Icons.folder_rounded);

  Widget get toWidget => toTile.toWidget;
}
