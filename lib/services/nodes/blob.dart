import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'dart:convert';
import 'group.dart';
import 'node.dart';
import '../../template/functions.dart';
import '../../layers/nodes/blob.dart';
import '../../sheets/node/group.dart';
import '../transfers/transfer.dart';
import '../../template/data.dart';
import '../../template/tile.dart';
import '../../sheets/image.dart';
import '../../sheets/text.dart';
import '../../functions.dart';
import '../endpoint.dart';
import '../../data.dart';

class BlobNode extends Node {
  Uint8List data = Uint8List(0);

  BlobNode({
    super.date,
    super.size,
    required super.path,
    required super.parent,
  });

  String get textData {
    try {
      return utf8.decode(data);
    } catch (e) {
      showSnack('$e', false);
      return 'ERROR';
    }
  }

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
    icon,
    '',
    openLayer,
    onHold: () => BlobNodeLayer(node: this).show(),
  );

  IconData get icon => {
    BlobType.text: Icons.list_alt_rounded,
    BlobType.image: Icons.crop_original_rounded,
  }[blobType]!;

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
    builder: (c) => GroupNodePageSheet(
      initialIndex: parent!.shownBlobs.indexOf(this),
      group: parent!,
    ),
  );

  bool get hasData => data.isNotEmpty;
  BlobType get blobType => BlobType.fromExtension(extension);

  Widget get subSheet {
    return {
      BlobType.image: ImageNodeSheet(blobNode: this, key: Key('$data')),
      BlobType.text: TextNodeSheet(blobNode: this, key: Key('$data')),
    }[blobType]!;
  }

  Future<void> saveChanges() async {
    if (blobType == BlobType.text) await update();
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

  Transfer get upload => Transfer(
    'Uploading $name',
    future: () async {
      await EndPoint().uploadNode(this);
      await parent!.refresh();
    }.call(),
  );

  @override
  Transfer get forceRemove =>
      Transfer('Removing $name', future: EndPoint().removeBlobNode(this));

  Transfer get update =>
      Transfer('Update $path', future: EndPoint().updateBlobNode(this));

  Transfer get download => Transfer(
    'Downloading $name',
    future: () async {
      await refresh();
      await FilePicker.platform.saveFile(fileName: name, bytes: data);
    }.call(),
  );
}
