import 'package:flutter/foundation.dart';
import 'network.dart';
import 'cache.dart';
import '../nodes/loadable.dart';
import '../nodes/subgroup.dart';
import '../nodes/bucket.dart';
import '../nodes/group.dart';
import '../nodes/root.dart';
import '../nodes/blob.dart';
import '../profile.dart';
import '../../data.dart';

class SubStorage with ChangeNotifier {
  late RootNode root;
  late Network network;
  late Cache cache;
  Profile profile;

  SubStorage({required this.profile}) {
    root = RootNode(subStorage: this);
    network = Network(storage: this);
    cache = Cache(storage: this);
    root.addListener(notifyListeners);
  }

  Future<void> copyBlobNode(BlobNode node, String dest) async {
    await network.copyBlobNode(node, dest);
    cache.copyBlobNode(node, dest);
  }

  Future casuallyRefresh(LoadableNode node) async {
    if (node.cacheStatus != Status.completed) {
      node.cacheStatus = Status.inProgress;
      await cache.refresh(node);
      node.cacheStatus = Status.completed;
    }
    if (Pref.autoRefresh.value) await remotelyRefresh(node);
  }

  Future remotelyRefresh(LoadableNode node) async {
    node.networkStatus = Status.inProgress;
    await network.refresh(node);
    node.networkStatus = Status.completed;
    if (node is BlobNode) cache.store(node);
    if (node is GroupNode) cache.uncacheDeprecatedSubNodes(node);
  }

  Future removeBlobNodes(List<BlobNode> nodes) async {
    await network.removeBlobNodes(nodes);
    cache.removeBlobNodes(nodes);
  }

  Future store(BlobNode node) async {
    await network.store(node);
    cache.store(node);
  }

  Future<void> uploadPaths(SubGroupNode parent, List<String?> paths) async {
    await network.uploadPaths(parent, paths);
    cache.uploadPaths(parent, paths);
  }

  Future createBucket(String name) async {
    await network.createBucket(name);
    cache.createBucket(name);
  }

  Future<void> removeBucket(BucketNode node) async {
    await network.removeBucket(node);
    cache.removeBucket(node);
  }

  Future<void> removeBlobNode(BlobNode node) => removeBlobNodes([node]);
}
