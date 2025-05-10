// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/nodes/group.dart';
import '../../services/nodes/blob.dart';
import '../../template/functions.dart';
import '../../template/layer.dart';
import '../../template/tile.dart';

class AddNodeLayer extends Layer {
  GroupNode parent;

  AddNodeLayer({required this.parent});
  @override
  void construct() {
    action = Tile('Add new node', Icons.add_rounded);
    list = [
      Tile('Blank', Icons.insert_drive_file_rounded, '', () async {
        final dest = await getInput(parent.path, 'Name');
        final newNode = BlobNode(parent: parent, path: dest);
        await newNode.upload();
        Navigator.of(context).pop();
      }),
      Tile('Files', Icons.description_rounded, '', () async {
        final result = await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result == null) return;
        await parent.uploadFiles(result.paths);
        showSnack('Done', true);
      }),
      Tile('Folder', Icons.folder_rounded, '', () async {
        final folderPath = await FilePicker.platform.getDirectoryPath();
        if (folderPath == null) return;
        print(await listAllSubEntities(folderPath));
        //await parent.uploadFiles(result.paths);
      }),
    ];
  }
}

Future<List<String>> listAllSubEntities(String folderPath) async {
  try {
    final directory = Directory(folderPath);
    final entities = await directory.list(recursive: true).toList();
    return entities.map((e) => e.path).toList();
  } catch (e) {
    showSnack('$e', false);
    throw Error();
  }
}
