import 'package:flutter/material.dart';
import 'bucket.dart';
import 'group.dart';
import '../../template/tile.dart';
import '../../functions.dart';

abstract class Node with ChangeNotifier {
  String path; //Path inside the bucket
  bool loaded = false;
  DateTime? date;
  String get name => nameFromPath(path);
  String get fullPath => '${bucketNode.name}/$path';
  GroupNode? parent;

  Node({required this.path, this.parent, this.date});

  Future<void> refresh();

  Tile get toTile => Tile();
  Widget get toWidget => toTile.toWidget;

  BucketNode get bucketNode {
    Node? node = this;
    while (node != null) {
      if (node is BucketNode) return node;
      node = node.parent!;
    }
    throw Error();
  }

  Future<void> refreshToRoot() async {
    List<Future> futures = [];
    Node? node = this;
    while (node != null) {
      futures.add(node.refresh());
      node = node.parent;
    }
    Future.wait(futures);
  }
}
