import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'bucket.dart';
import '../transfers/transfer.dart';
import '../storage/storage.dart';

class RootNode extends ChangeNotifier {
  static final instance = RootNode.internal();
  factory RootNode() => instance;
  RootNode.internal();

  List<BucketNode> buckets = [];
  bool _loaded = false;

  bool get loaded => _loaded;
  set loaded(bool b) {
    _loaded = b;
    notifyListeners();
  }

  void loadBuckets(List<Bucket> list) {
    buckets = list.map((bucket) {
      return BucketNode(bucket: bucket);
    }).toList();
    buckets.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void notify() => notifyListeners();

  Future<void> refresh() => Storage().refreshRoot(this);

  Transfer createBucket(String name) => Transfer(
    'Creating bucket $name',
    future: () async {
      await Storage().createBucket(name);
      refresh();
    }.call(),
  );
}
