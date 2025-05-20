import 'package:flutter/material.dart';
import 'bucket.dart';
import 'group.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';
import '../transfers/transfer.dart';
import '../../functions.dart';
import '../../data.dart';

abstract class Node with ChangeNotifier {
  String path; //Path inside the bucket
  bool _loaded = false;
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

  bool get loaded => _loaded;
  set loaded(bool b) {
    _loaded = b;
    notifyListeners();
  }

  String get fullPath => '${bucketNode.name}/$path';

  Node({required this.path, this.parent, this.date, this.size});

  Future<void> refresh();
  Transfer get forceRemove;
  void notify() => notifyListeners();

  void tryRemove() =>
      showSnack('Press to confirm', false, onTap: () => forceRemove.call());

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

  Transfer get refreshToRoot {
    List<Future> futures = [];
    Node? node = this;
    while (node != null) {
      futures.add(node.refresh());
      node = node.parent;
    }
    return Transfer('Refreshing', future: Future.wait(futures));
  }
}
