import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'package:minio/minio.dart';
import 'package:minio/io.dart';
import 'dart:typed_data';
import 'nodes/prefix.dart';
import 'nodes/group.dart';
import 'nodes/blob.dart';
import 'nodes/node.dart';
import 'profile.dart';
import '../../template/functions.dart';
import '../../functions.dart';

class EndPoint with ChangeNotifier {
  static final instance = EndPoint.internal();

  factory EndPoint() => instance;
  EndPoint.internal();

  Minio get minio => Profiles().current.toMinio;

  Future<List<Bucket>> listBuckets() => minio.listBuckets();

  Future<void> moveBlobNode(BlobNode node, String dest) async {
    await copyBlobNode(node, dest);
    await removeBlobNode(node);
  }

  Future<List<Node>> listNodes(GroupNode node) async {
    final result = await minio
        .listObjects(node.bucketNode.name, prefix: node.path)
        .first;

    final groups = result.prefixes.map((path) {
      return PrefixNode(path: path, parent: node);
    }).toList();
    final blobs = result.objects.map((object) {
      return BlobNode.fromObject(parent: node, object: object);
    }).toList();
    groups.sort((a, b) => a.name.compareTo(b.name));
    blobs.sort((a, b) => a.name.compareTo(b.name));
    return [...groups, ...blobs];
  }

  Future<Uint8List> loadBlobNode(BlobNode node) async {
    final stream = await streamBlobNode(node);
    final bytesList = <int>[];
    await for (final chunk in stream) {
      bytesList.addAll(chunk);
    }
    return Uint8List.fromList(bytesList);
  }

  Future<MinioByteStream> streamBlobNode(BlobNode node) {
    return minio.getObject(node.bucketNode.name, node.path);
  }

  Future<String> updateBlobNode(BlobNode node) {
    return minio.putObject(
      node.bucketNode.name,
      node.path,
      Stream.value(node.data),
    );
  }

  Future<void> copyBlobNode(BlobNode node, String dest) {
    return minio.copyObject(node.bucketNode.name, dest, node.fullPath);
  }

  Future<void> removeBlobNode(BlobNode node) => removeBlobNodes([node]);

  Future<void> removeBlobNodes(List<BlobNode> nodes) async {
    final paths = nodes.map((node) => node.path).toList();
    await minio.removeObjects(nodes.first.bucketNode.name, paths);
  }

  Future<void> uploadNode(BlobNode node) async {
    await minio.putObject(
      node.bucketNode.name,
      node.path,
      Stream.value(node.data),
    );
  }

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
}
