import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'dart:io';
import 'storage.dart';
import '../../functions.dart';
import '../nodes/prefix.dart';
import '../nodes/bucket.dart';
import '../nodes/group.dart';
import '../nodes/root.dart';
import '../nodes/blob.dart';
import '../nodes/node.dart';
import '../../data.dart';

class Cache extends StorageProvider {
  String get cachePath => '${Pref.cachePath.value}/S3';
  String get tempPath => '${Pref.cachePath.value}/Temp';
  Directory get cacheDir => Directory(cachePath);

  String nodePath(Node node) => '$cachePath/${node.fullPath}';
  Directory dirFromGroup(GroupNode node) => Directory(nodePath(node));
  File fileFromNode(BlobNode node) => File(nodePath(node));

  @override
  Future<void> refreshRoot(RootNode root) async {
    try {
      final result = cacheDir.listSync().map((e) {
        return Bucket(null, nameFromPath(e.path));
      }).toList();
      root.loadBuckets(result);
    } catch (e) {
      debugPrint('Loading fail for root: $e');
    }
  }

  @override
  Future<void> refreshGroup(GroupNode group) async {
    try {
      final nodes = <Node>[];
      final directory = dirFromGroup(group);
      for (final entity in directory.listSync()) {
        var path = entity.path.replaceFirst('${nodePath(group)}/', '');
        path = path.replaceFirst(nodePath(group), '');
        if (entity is Directory) {
          nodes.add(PrefixNode(path: path, parent: group));
        }
        if (entity is File) {
          nodes.add(
            BlobNode(
              parent: group,
              path: path,
              size: entity.statSync().size,
              date: entity.statSync().changed,
            ),
          );
        }
        group.nodes = nodes;
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> loadBlobNode(BlobNode node) async {
    try {
      node.data = await fileFromNode(node).readAsBytes();
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> uploadNode(BlobNode node) => updateBlobNode(node);

  @override
  Future<void> updateBlobNode(BlobNode node) async {
    try {
      final file = fileFromNode(node);
      await file.create(recursive: true);
      await fileFromNode(node).writeAsBytes(node.data);
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> copyBlobNode(BlobNode node, String dest) async {
    try {
      final file = fileFromNode(node);
      await file.copy('$cachePath/${node.parent!.name}/$dest');
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> removeBlobNodes(List<BlobNode> nodes) async {
    try {
      for (final node in nodes) {
        await fileFromNode(node).delete();
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> createBucket(String name) async {
    try {
      final directory = Directory('$cachePath/$name');
      await directory.create();
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> removeBucket(BucketNode bucket) async {
    try {
      final directory = dirFromGroup(bucket);
      await directory.delete(recursive: true);
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> uploadPaths(GroupNode parent, List<String?> paths) async {
    //TODO
  }

  Future<File> tempFileFromBlobNode(BlobNode node) async {
    final file = File('$tempPath/${node.fullPath}');
    await file.create(recursive: true);
    await file.writeAsBytes(node.data);
    print(formatBytes(file.statSync().size));
    return file;
  }
}
