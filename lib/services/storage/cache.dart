import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'dart:io';
import 'provider.dart';
import '../../template/functions.dart';
import '../../functions.dart';
import '../nodes/prefix.dart';
import '../nodes/bucket.dart';
import '../nodes/group.dart';
import '../nodes/root.dart';
import '../nodes/blob.dart';
import '../nodes/sub.dart';
import '../../data.dart';

class Cache extends StorageProvider {
  Directory get cacheDir => Directory(cachePath);
  String get accessKey => storage.profile.accessKey;
  String get tempPath {
    if (Pref.cachePath.isInitial) throw Exception();
    return '${Pref.cachePath.value}/Temp/$accessKey';
  }

  String get cachePath {
    if (Pref.cachePath.isInitial) throw Exception();
    return '${Pref.cachePath.value}/S3/$accessKey';
  }

  Cache({required super.storage});

  Directory dirFromGroup(GroupNode node) => Directory(nodePath(node));
  File fileFromNode(BlobNode node) => File(nodePath(node));
  String nodePath(SubNode node) => '$cachePath/${node.fullPath}';

  @override
  Future<void> refreshRoot(RootNode r) async => refreshRootSync(r);

  void refreshRootSync(RootNode root) {
    try {
      root.buckets = cacheDir.listSync().map((entity) {
        return BucketNode(
          literalBucket: Bucket(null, nameFromPath(entity.path)),
          parent: storage.root,
          fsEntity: entity,
        );
      }).toList();
    } catch (e) {
      debugPrint('Loading fail for root: $e');
    }
  }

  @override
  Future<void> refreshGroup(GroupNode g) async => refreshGroupSync(g);

  void tryClear() => showSnack(
    'Press to confirm',
    false,
    onTap: () async {
      await cacheDir.delete(recursive: true);
      storage.root.refreshCachedNodes();
    },
  );

  void refreshGroupSync(GroupNode group) {
    try {
      final nodes = <SubNode>[];
      final bucketName = group.bucket.name;
      final directory = dirFromGroup(group);
      for (final entity in directory.listSync()) {
        var path = entity.path.replaceFirst('$cachePath/$bucketName/', '');
        if (entity is Directory) {
          nodes.add(PrefixNode(path: path, parent: group, fsEntity: entity));
        }
        if (entity is File) {
          nodes.add(
            BlobNode(
              parent: group,
              path: path,
              size: entity.statSync().size,
              date: entity.statSync().changed,
              fsEntity: entity,
            ),
          );
        }
        group.subnodes = nodes;
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> refreshBlob(BlobNode node) async {
    try {
      node.data = await fileFromNode(node).readAsBytes();
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Future<void> store(BlobNode node) async {
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
      await file.copy('$cachePath/${node.bucket.name}/$dest');
      //TODO test
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
    return file;
  }
}
