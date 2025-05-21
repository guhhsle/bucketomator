import 'dart:io';
import 'package:flutter/material.dart';
import 'package:s3/services/nodes/loadable.dart';
import 'bucket.dart';
import 'group.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';
import '../../layers/nodes/cache.dart';
import '../transfers/transfer.dart';
import '../../functions.dart';
import '../../data.dart';

abstract class SubNode extends LoadableNode {
  String path; //Path inside the bucket
  FileSystemEntity? fsEntity;
  GroupNode? parent;
  DateTime? date;
  int? size;

  SubNode({
    required this.path,
    this.parent,
    this.date,
    this.size,
    this.fsEntity,
  });

  String get name => nameFromPath(path);
  String get displayName {
    if (Pref.autoCapitalise.value) return capitalize(name);
    return name;
  }

  String get fullPath => '${bucketNode.name}/$path';

  Transfer get forceRemove;

  void tryRemove() =>
      showSnack('Press to confirm', false, onTap: () => forceRemove.call());

  Tile get toTile;
  Widget get toWidget => toTile.toWidget;

  int get depth {
    if (this is BucketNode) return 0;
    int result = -1;
    SubNode? node = this;
    while (node != null) {
      node = node.parent;
      result++;
    }
    return result;
  }

  BucketNode get bucketNode {
    SubNode? node = this;
    while (node != null) {
      if (node is BucketNode) return node;
      node = node.parent!;
    }
    throw Error();
  }

  Transfer get refreshToRoot {
    List<Future> futures = [];
    SubNode? node = this;
    while (node != null) {
      futures.add(node.refresh(true));
      node = node.parent;
    }
    return Transfer('Refreshing', future: Future.wait(futures));
  }

  Tile get toCacheTile {
    final tile = toTile;
    tile.title = name.padLeft(name.length + depth, '.');
    tile.onHold = CachedNodeLayer(node: this).show;
    return tile;
  }
}
