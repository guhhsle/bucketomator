import 'substorage.dart';
import '../nodes/loadable.dart';
import '../nodes/bucket.dart';
import '../nodes/group.dart';
import '../nodes/blob.dart';
import '../nodes/root.dart';

abstract class StorageProvider {
  SubStorage storage;
  StorageProvider({required this.storage});

  Future<void> store(BlobNode node);
  Future<void> refreshBlob(BlobNode node);
  Future<void> refreshRoot(RootNode root);
  Future<void> refreshGroup(GroupNode group);
  Future<void> uploadPaths(GroupNode parent, List<String?> paths);
  Future<void> copyBlobNode(BlobNode node, String dest);
  Future<void> removeBlobNodes(List<BlobNode> nodes);
  Future<void> removeBucket(BucketNode node);
  Future<void> createBucket(String name);

  Future<void> refresh(LoadableNode node) async {
    if (node is RootNode) return refreshRoot(node);
    if (node is GroupNode) return refreshGroup(node);
    if (node is BlobNode) return refreshBlob(node);
  }
}
