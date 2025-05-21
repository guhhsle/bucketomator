import 'package:minio/minio.dart';
import 'package:minio/io.dart';
import 'dart:typed_data';
import 'storage.dart';
import '../../template/functions.dart';
import '../../functions.dart';
import '../nodes/bucket.dart';
import '../nodes/prefix.dart';
import '../nodes/group.dart';
import '../nodes/root.dart';
import '../nodes/blob.dart';

class Server extends StorageProvider {
  Minio get minio => profile.toMinio;

  @override
  Future<void> refreshRoot(RootNode root) async {
    final result = await minio.listBuckets();
    root.buckets = result.map((b) => BucketNode(bucket: b)).toList();
  }

  @override
  Future<void> refreshGroup(GroupNode group) async {
    final result = await minio
        .listObjects(group.bucketNode.name, prefix: group.path)
        .first;
    group.subnodes = [
      ...result.prefixes.map((p) => PrefixNode(path: p, parent: group)),
      ...result.objects.map(
        (o) => BlobNode.fromObject(parent: group, object: o),
      ),
    ];
  }

  @override
  Future<void> loadBlobNode(BlobNode node) async {
    final stream = await streamBlobNode(node);
    final bytesList = <int>[];
    await for (final chunk in stream) {
      bytesList.addAll(chunk);
    }
    node.data = Uint8List.fromList(bytesList);
  }

  Future<MinioByteStream> streamBlobNode(BlobNode node) =>
      minio.getObject(node.bucketNode.name, node.path);

  @override
  Future<String> updateBlobNode(BlobNode node) =>
      minio.putObject(node.bucketNode.name, node.path, Stream.value(node.data));

  @override
  Future<void> copyBlobNode(BlobNode node, String dest) =>
      minio.copyObject(node.bucketNode.name, dest, node.fullPath);

  @override
  Future<void> removeBlobNodes(List<BlobNode> nodes) async {
    final paths = nodes.map((node) => node.path).toList();
    await minio.removeObjects(nodes.first.bucketNode.name, paths);
    for (final node in nodes) {
      node.parent?.refreshToRoot();
    }
  }

  @override
  Future<void> uploadNode(BlobNode node) =>
      minio.putObject(node.bucketNode.name, node.path, Stream.value(node.data));

  @override
  Future<void> uploadPaths(GroupNode parent, List<String?> paths) async {
    final length = paths.length;
    for (int i = 0; i < length; i++) {
      final filePath = paths[i];
      if (filePath == null) continue;
      final name = nameFromPath(filePath);
      final bucketPath = parent.path + name;
      try {
        showSnack('${i + 1}/$length $name', true);
        await minio.fPutObject(parent.bucketNode.name, bucketPath, filePath);
      } catch (e) {
        showSnack('Error when uploading $name $e', false);
      }
    }
  }

  @override
  Future<void> createBucket(String name) async {
    try {
      await minio.makeBucket(name);
    } catch (e) {
      showSnack('$e', false);
    }
  }

  @override
  Future<void> removeBucket(BucketNode node) => minio.removeBucket(node.name);
}
