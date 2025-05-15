import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'dart:convert';
import 'group.dart';
import 'node.dart';
import '../../layers/nodes/blob.dart';
import '../../sheets/image_node.dart';
import '../../sheets/text_node.dart';
import '../transfers/transfer.dart';
import '../../template/data.dart';
import '../../template/tile.dart';
import '../../functions.dart';
import '../endpoint.dart';

class BlobNode extends Node {
  Uint8List data = Uint8List(0);

  BlobNode({
    super.date,
    super.size,
    required super.path,
    required super.parent,
  });

  String get textData => utf8.decode(data);
  String get extension => extensionFromPath(path);
  set textData(String s) => data = utf8.encode(s);

  static BlobNode fromObject({
    required GroupNode parent,
    required Object object,
  }) => BlobNode(
    date: object.lastModified,
    size: object.size,
    path: object.key!,
    parent: parent,
  );

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

  void openLayer() => showModalBottomSheet(
    barrierLabel: 'Barrier',
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (c) => sheet,
  );

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

  Transfer copyTo(String dest) => Transfer(
    'Copying $name to $dest',
    future: () async {
      await EndPoint().copyBlobNode(this, dest);
      await parent?.refresh();
    }.call(),
  );

  Transfer moveTo(String dest) {
    final transfer = Transfer('Moving $name to $dest');
    transfer.future = () async {
      await copyTo(dest).copyWith(parent: transfer).call();
      await forceRemove.copyWith(parent: transfer).call();
    }.call();
    return transfer;
  }

  Transfer get upload =>
      Transfer('Uploading $name', future: EndPoint().uploadNode(this));

  @override
  Transfer get forceRemove =>
      Transfer('Removing $name', future: EndPoint().removeBlobNode(this));

  Transfer get update =>
      Transfer('Update $path', future: EndPoint().updateBlobNode(this));
}
