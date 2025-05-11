import 'package:flutter/material.dart';
import '../../data.dart';
import 'bucket.dart';
import 'group.dart';
import '../../template/tile.dart';
import '../../functions.dart';

abstract class Node with ChangeNotifier {
  String path; //Path inside the bucket
  bool loaded = false;
  GroupNode? parent;
  DateTime? date;
  int? size;

  String get name => nameFromPath(path);
  String get displayName {
    if (Pref.autoCapitalise.value) {
      return capitalize(name);
    } else {
      return name;
    }
  }

  String get fullPath => '${bucketNode.name}/$path';

  Node({required this.path, this.parent, this.date, this.size});

  Future<void> refresh();

  Tile get toTile;
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
