import 'package:flutter/material.dart';
import 'bucket.dart';
import '../../template/functions.dart';
import '../endpoint.dart';

class RootNode extends ChangeNotifier {
  List<BucketNode> buckets = [];
  bool loaded = false;

  static final instance = RootNode.internal();
  factory RootNode() => instance;
  RootNode.internal();

  Future<void> refresh() async {
    try {
      loaded = false;
      final result = await EndPoint().listBuckets();
      buckets = result.map((bucket) {
        return BucketNode(bucket: bucket);
      }).toList();
      buckets.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      showSnack('$e', false);
    }
    loaded = true;
    notifyListeners();
  }
}
