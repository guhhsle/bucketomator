import 'server.dart';
import 'cache.dart';
import '../nodes/bucket.dart';
import '../nodes/group.dart';
import '../nodes/root.dart';
import '../nodes/blob.dart';
import '../profile.dart';
import '../../data.dart';

abstract class StorageProvider {
  Profile get profile => Profiles().current;
  Future<void> refreshRoot(RootNode root);
  Future<void> refreshGroup(GroupNode group);
  Future<void> updateBlobNode(BlobNode node);
  Future<void> loadBlobNode(BlobNode node);
  Future<void> removeBlobNode(BlobNode node) => removeBlobNodes([node]);
  Future<void> uploadPaths(GroupNode parent, List<String?> paths);
  Future<void> copyBlobNode(BlobNode node, String dest);
  Future<void> removeBlobNodes(List<BlobNode> nodes);
  Future<void> removeBucket(BucketNode node);
  Future<void> createBucket(String name);
  Future<void> uploadNode(BlobNode node);
}

class Storage {
  Profile get profile => Profiles().current;
  Future<void> removeBlobNode(BlobNode node) => removeBlobNodes([node]);
  static final instance = Storage.internal();
  factory Storage() => instance;
  Storage.internal();

  final root = RootNode();
  final server = Server();
  final cache = Cache();

  Future<void> copyBlobNode(BlobNode node, String dest) async {
    await server.copyBlobNode(node, dest);
    cache.copyBlobNode(node, dest);
  }

  Future refreshRoot(RootNode root, bool force) async {
    root.cacheStatus = Status.inProgress;
    await cache.refreshRoot(root);
    root.cacheStatus = Status.completed;
    if (force || Pref.autoRefresh.value) {
      root.serverStatus = Status.inProgress;
      await server.refreshRoot(root);
      root.serverStatus = Status.completed;
    }
  }

  Future refreshGroup(GroupNode node, bool force) async {
    node.cacheStatus = Status.inProgress;
    await cache.refreshGroup(node);
    node.cacheStatus = Status.completed;
    if (force || Pref.autoRefresh.value) {
      node.serverStatus = Status.inProgress;
      await server.refreshGroup(node);
      node.serverStatus = Status.completed;
    }
  }

  Future loadBlobNode(BlobNode node, bool force) async {
    node.cacheStatus = Status.inProgress;
    await cache.loadBlobNode(node);
    node.cacheStatus = Status.completed;
    if (force || Pref.autoRefresh.value) {
      node.serverStatus = Status.inProgress;
      await server.loadBlobNode(node);
      cache.updateBlobNode(node);
      node.serverStatus = Status.completed;
    }
  }

  Future removeBlobNodes(List<BlobNode> nodes) async {
    await server.removeBlobNodes(nodes);
    cache.removeBlobNodes(nodes);
  }

  Future updateBlobNode(BlobNode node) async {
    await server.updateBlobNode(node);
    cache.updateBlobNode(node);
  }

  Future uploadNode(BlobNode node) async {
    await server.uploadNode(node);
    cache.uploadNode(node);
  }

  Future<void> uploadPaths(GroupNode parent, List<String?> paths) async {
    await server.uploadPaths(parent, paths);
    cache.uploadPaths(parent, paths);
  }

  Future createBucket(String name) async {
    await server.createBucket(name);
    cache.createBucket(name);
  }

  Future<void> removeBucket(BucketNode node) async {
    await server.removeBucket(node);
    cache.removeBucket(node);
  }
}
