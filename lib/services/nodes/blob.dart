import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'dart:convert';
import 'group.dart';
import '../../template/class/tile.dart';
import '../../widgets/nodes/image.dart';
import '../../widgets/nodes/video.dart';
import '../../widgets/nodes/text.dart';
import '../../template/functions.dart';
import '../../widgets/nodes/pdf.dart';
import '../../pages/nodes/blobs.dart';
import '../../layers/nodes/blob.dart';
import '../../sheets/node/blobs.dart';
import '../transfers/transfer.dart';
import '../../template/data.dart';
import '../storage/storage.dart';
import '../../functions.dart';
import '../../data.dart';
import 'sub.dart';

class BlobNode extends SubNode {
  Uint8List _data = Uint8List(0);
  final textController = TextEditingController();

  BlobNode({
    super.date,
    super.size,
    super.fsEntity,
    required super.path,
    required super.parent,
  });

  String get textData {
    if (blobType == BlobType.image) return 'IMAGE';
    try {
      return utf8.decode(data);
    } catch (e) {
      return 'ERROR';
    }
  }

  Uint8List get data => _data;
  set data(Uint8List u) {
    _data = u;
    textController.text = textData;
    notifyListeners();
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
  Tile get toTile => Tile.complex(displayName, icon, '', () {
    if (Pref.sheetBlobs.value) {
      openLayer();
    } else {
      goToPage(
        BlobNodesPage(
          group: parent!,
          initialIndex: parent!.shownBlobs.indexOf(this),
        ),
      );
    }
  }, onHold: () => BlobNodeLayer(node: this).show());

  IconData get icon =>
      {
        BlobType.pdf: Icons.picture_as_pdf_rounded,
        BlobType.image: Icons.crop_original_rounded,
        BlobType.video: Icons.movie_rounded,
      }[blobType] ??
      Icons.list_alt_rounded;

  @override
  Future<void> refresh(bool force) => Storage().loadBlobNode(this, force);

  void openLayer() => showModalBottomSheet(
    barrierLabel: 'Barrier',
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (c) => BlobNodesSheet(
      initialIndex: parent!.shownBlobs.indexOf(this),
      group: parent!,
    ),
  );

  bool get hasData => serverStatus == Status.completed || data.isNotEmpty;
  BlobType get blobType => BlobType.fromExtension(extension);

  Widget get subWidget =>
      {
        BlobType.image: ImageNodeWidget(blobNode: this),
        BlobType.video: VideoNodeWidget(blobNode: this),
        BlobType.pdf: PDFNodeWidget(blobNode: this),
      }[blobType] ??
      TextNodeWidget(blobNode: this);

  Future<void> saveChanges() async {
    if (blobType == BlobType.text) {
      textData = textController.text;
      await update();
    }
  }

  Transfer copyTo(String dest) => Transfer(
    'Copying $name to $dest',
    future: () async {
      await Storage().copyBlobNode(this, dest);
      await parent?.refresh(true);
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
      await Storage().uploadNode(this);
      await parent?.refresh(true);
    }.call(),
  );

  @override
  Transfer get forceRemove =>
      Transfer('Removing $name', future: Storage().removeBlobNode(this));

  Transfer get update =>
      Transfer('Update $path', future: Storage().updateBlobNode(this));

  Transfer get download => Transfer(
    'Downloading $name',
    future: () async {
      await refresh(!hasData);
      await FilePicker.platform.saveFile(fileName: name, bytes: data);
    }.call(),
  );
}
