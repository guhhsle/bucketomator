import 'package:flutter/material.dart';
import 'package:minio/models.dart';
import 'storage.dart';
import 'folder.dart';
import '../services/subobject.dart';
import '../template/functions.dart';
import '../template/tile.dart';
import '../pages/folder.dart';

class Subfolder extends Folder {
  final Bucket bucket;
  final String prefix;
  final Folder parent;
  DateTime? date;

  Subfolder({required this.parent, required this.bucket, this.prefix = ''});

  @override
  String get path {
    if (prefix == '') return bucket.name;
    return '${bucket.name}/$formatPrefix';
  }

  String get formatPrefix => prefix.substring(0, prefix.length - 1);

  @override
  Future<void> refresh() async {
    final result = await Storage().minio
        .listObjects(bucket.name, prefix: prefix)
        .first;

    subfolders = result.prefixes.map((prefix) {
      return Subfolder(bucket: bucket, prefix: prefix, parent: this);
    }).toList();
    subobjects = result.objects.map((object) {
      return Subobject.fromObject(parent: this, object: object);
    }).toList();
    subfolders.sort((a, b) => a.name.compareTo(b.name));
    subobjects.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  @override
  Tile get toTile {
    return Tile(name, Icons.folder_rounded, '', () async {
      goToPage(FolderPage(folder: this));
    });
  }
}
