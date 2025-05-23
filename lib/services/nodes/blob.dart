import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'dart:convert';
import 'dart:io';
import 'group.dart';
import 'sub.dart';
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
import '../../functions.dart';
import '../../data.dart';

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
  Tile get toTile => Tile.complex(
    displayName,
    icon,
    '',
    () => open(),
    onHold: () => BlobNodeLayer(node: this).show(),
  );

  @override
  void open() {
    casuallyRefresh();
    ((('CASUALLY')));
    if (Pref.sheetBlobs.value) {
      showModalBottomSheet(
        barrierLabel: 'Barrier',
        context: navigatorKey.currentContext!,
        isScrollControlled: true,
        barrierColor: Colors.black.withValues(alpha: 0.3),
        builder: (c) => BlobNodesSheet(
          initialIndex: group.shownBlobs.indexOf(this),
          group: group,
        ),
      );
    } else {
      goToPage(
        BlobNodesPage(
          group: group,
          initialIndex: group.shownBlobs.indexOf(this),
        ),
      );
    }
  }

  IconData get icon =>
      {
        BlobType.pdf: Icons.picture_as_pdf_rounded,
        BlobType.image: Icons.crop_original_rounded,
        BlobType.video: Icons.movie_rounded,
      }[blobType] ??
      Icons.list_alt_rounded;

  bool get isSynced => networkStatus == Status.completed || data.isNotEmpty;
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
      await store.call();
    }
  }

  Transfer copyTo(String dest) => Transfer(
    'Copying $name to $dest',
    future: () async {
      await storage.copyBlobNode(this, dest);
      await parent?.remotelyRefresh();
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

  Transfer get store => Transfer(
    'Uploading $name',
    future: () async {
      await storage.store(this);
      await parent?.remotelyRefresh();
    }.call(),
  );

  @override
  Transfer get forceRemove =>
      Transfer('Removing $name', future: storage.removeBlobNode(this));

  Transfer get downloadRefreshed => Transfer(
    'Downloading $name',
    future: () async {
      await remotelyRefresh();
      await FilePicker.platform.saveFile(fileName: name, bytes: data);
    }.call(),
  );

  Transfer get downloadAsIs => Transfer(
    'Downloading $name as is',
    future: () async {
      await FilePicker.platform.saveFile(fileName: name, bytes: data);
    }.call(),
  );

  Future<File> storeTemporarily() => cache.tempFileFromBlobNode(this);
}
