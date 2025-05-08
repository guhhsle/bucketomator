import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'dart:convert';
import 'subfolder.dart';
import 'storage.dart';
import 'subitem.dart';
import '../template/tile.dart';
import '../template/data.dart';
import '../sheets/image.dart';
import '../sheets/text.dart';
import '../functions.dart';

class Subobject extends StorageItem {
  final Subfolder parent;
  DateTime? date;
  String key;
  int? size;
  Uint8List? data;

  @override
  String get path => key;

  Subobject({
    required this.parent,
    required this.key,
    required this.size,
    this.date,
  });

  set textData(String s) => data = utf8.encode(s);
  String get textData => utf8.decode(data ?? []);
  String get extension => fileExtension(key);
  Bucket get bucket => parent.bucket;

  static Subobject fromObject({
    required Subfolder parent,
    required Object object,
  }) {
    return Subobject(
      parent: parent,
      key: object.key!,
      size: object.size,
      date: object.lastModified,
    );
  }

  @override
  Tile get toTile => Tile(name, Icons.list_alt_rounded, '', openLayer);

  @override
  Future<void> refresh() async {
    final stream = await Storage().minio.getObject(parent.bucket.name, key);
    data = await streamToBytes(stream);
    notifyListeners();
  }

  Future<Uint8List> streamToBytes(Stream<List<int>> stream) async {
    final bytesList = <int>[];
    await for (final chunk in stream) {
      bytesList.addAll(chunk);
    }
    return Uint8List.fromList(bytesList);
  }

  Future<void> update() async {
    await Storage().minio.putObject(bucket.name, key, Stream.value(data!));
  }

  void openLayer() {
    showModalBottomSheet(
      barrierLabel: 'Barrier',
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (c) => sheet,
    );
  }

  static const extensions = {
    'Image': ['jpg', 'png'],
  };

  Widget get sheet {
    String filetype = 'Text';
    for (final entry in extensions.entries) {
      if (entry.value.contains(extension)) {
        filetype = entry.key;
        break;
      }
    }
    return {
      'Image': ImageObject(subobject: this, key: Key('$hashCode')),
      'Text': TextObject(subobject: this, key: Key('$hashCode')),
    }[filetype]!;
  }
}
