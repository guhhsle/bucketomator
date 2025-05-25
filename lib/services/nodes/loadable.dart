import 'package:flutter/material.dart';
import 'bucket.dart';
import 'root.dart';
import '../storage/substorage.dart';
import '../storage/network.dart';
import '../storage/cache.dart';
import '../../data.dart';
import 'subgroup.dart';

abstract class LoadableNode with ChangeNotifier {
  LoadableNode? parent;
  Status _cacheStatus = Status.pending;
  Status _networkStatus = Status.pending;
  SubStorage get storage => root.subStorage;
  Network get network => storage.network;
  Cache get cache => storage.cache;

  LoadableNode({this.parent});

  bool get isEmpty;
  Status get networkStatus => _networkStatus;
  Status get cacheStatus => _cacheStatus;

  set cacheStatus(Status s) {
    _cacheStatus = s;
    notifyListeners();
  }

  set networkStatus(Status s) {
    _networkStatus = s;
    notifyListeners();
  }

  Future<void> casuallyRefresh() => storage.casuallyRefresh(this);
  Future<void> remotelyRefresh() => storage.remotelyRefresh(this);

  //ancestors refers to ancestors AND this
  List<LoadableNode> get ancestors {
    final list = <LoadableNode>[];

    LoadableNode? node = this;
    while (node != null) {
      list.add(node);
      node = node.parent;
    }
    return list;
  }

  int get depth => ancestors.length - 2;
  SubGroupNode get group => parent as SubGroupNode;
  RootNode get root => ancestors.whereType<RootNode>().first;
  BucketNode get bucket => ancestors.whereType<BucketNode>().first;
}
