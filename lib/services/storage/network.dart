import 'package:minio/minio.dart';
import 'package:minio/io.dart';
import 'dart:typed_data';
import '../nodes/subgroup.dart';
import 'provider.dart';
import '../../template/functions.dart';
import '../../functions.dart';
import '../nodes/bucket.dart';
import '../nodes/prefix.dart';
import '../nodes/root.dart';
import '../nodes/blob.dart';

class Network extends StorageProvider {
  Minio get minio => storage.profile.toMinio;

  Network({required super.storage});

  @override
  Future<void> refreshRoot(RootNode root) async {
    final result = await minio.listBuckets();
    root.subnodes = result.map((b) {
      return BucketNode(literalBucket: b, parent: root);
    }).toList();
  }

  @override
  Future<void> refreshSubGroup(SubGroupNode group) async {
    final result = await minio
        .listObjects(group.bucket.name, prefix: group.path)
        .first;
    group.subnodes = [
      ...result.prefixes.map((p) => PrefixNode(path: p, parent: group)),
      ...result.objects.map(
        (o) => BlobNode.fromObject(parent: group, object: o),
      ),
    ];
  }

  @override
  Future<void> refreshBlob(BlobNode node) async {
    final stream = await streamBlobNode(node);
    final bytesList = <int>[];
    await for (final chunk in stream) {
      bytesList.addAll(chunk);
    }
    node.data = Uint8List.fromList(bytesList);
  }

  Future<MinioByteStream> streamBlobNode(BlobNode node) =>
      minio.getObject(node.bucket.name, node.path);

  @override
  Future<void> copyBlobNode(BlobNode node, String dest) =>
      minio.copyObject(node.bucket.name, dest, node.fullPath);

  @override
  Future<void> removeBlobNodes(List<BlobNode> nodes) {
    final paths = nodes.map((node) => node.path).toList();
    return minio.removeObjects(nodes.first.bucket.name, paths);
  }

  @override
  Future<void> store(BlobNode node) =>
      minio.putObject(node.bucket.name, node.path, Stream.value(node.data));

  @override
  Future<void> uploadPaths(SubGroupNode parent, List<String?> paths) async {
    final length = paths.length;
    for (int i = 0; i < length; i++) {
      final filePath = paths[i];
      if (filePath == null) continue;
      final name = nameFromPath(filePath);
      final bucketPath = parent.path + name;
      try {
        showSnack('${i + 1}/$length $name', true);
        await minio.fPutObject(parent.bucket.name, bucketPath, filePath);
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
