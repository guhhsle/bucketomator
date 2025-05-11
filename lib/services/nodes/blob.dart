import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'package:s3/template/functions.dart';
import 'dart:convert';
import 'group.dart';
import 'node.dart';
import '../../layers/nodes/blob.dart';
import '../../sheets/image_node.dart';
import '../../sheets/text_node.dart';
import '../../template/data.dart';
import '../../template/tile.dart';
import '../../functions.dart';
import '../endpoint.dart';

class BlobNode extends Node {
  Uint8List data = Uint8List(0);

  BlobNode({
    required super.parent,
    required super.path,
    super.size,
    super.date,
  });

  set textData(String s) => data = utf8.encode(s);
  String get extension => extensionFromPath(path);
  String get textData => utf8.decode(data);

  static BlobNode fromObject({
    required GroupNode parent,
    required Object object,
  }) {
    return BlobNode(
      parent: parent,
      path: object.key!,
      size: object.size,
      date: object.lastModified,
    );
  }

  @override
  Tile get toTile => Tile.complex(
    displayName,
    Icons.list_alt_rounded,
    '',
    openLayer,
    onHold: () => BlobNodeLayer(node: this).show(),
  );

  @override
  Future<void> refresh() async {
    loaded = false;
    notifyListeners();
    data = await EndPoint().loadBlobNode(this);
    loaded = true;
    notifyListeners();
  }

  Future<void> update() async {
    await EndPoint().updateBlobNode(this);
    notifyListeners();
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
    'Image': ['jpg', 'png', 'gif'],
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
      'Image': ImageNodeSheet(blobNode: this, key: Key('$hashCode')),
      'Text': TextNodeSheet(blobNode: this, key: Key('$hashCode')),
    }[filetype]!;
  }

  Future<void> moveTo(String dest) async {
    await EndPoint().moveBlobNode(this, dest);
    path = dest;
    parent!.refresh();
  }

  void tryRemove() {
    showSnack(
      'Press to confirm',
      false,
      onTap: () async {
        await forceRemove();
        showSnack('Removed $name', false);
      },
    );
  }

  Future<void> copyTo(String dest) async {
    await EndPoint().copyBlobNode(this, dest);
    parent!.refresh();
  }

  Future<void> upload() async {
    await EndPoint().uploadNode(this);
    parent!.refresh();
  }

  Future<void> forceRemove() async {
    await EndPoint().removeBlobNode(this);
    parent!.refreshToRoot();
  }
}
