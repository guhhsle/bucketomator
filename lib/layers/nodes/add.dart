// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/nodes/group.dart';
import '../../template/class/layer.dart';
import '../../services/nodes/blob.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';

class AddNodeLayer extends Layer {
  GroupNode parent;

  AddNodeLayer({required this.parent});
  @override
  void construct() {
    action = Tile('Add new node', Icons.add_rounded);
    list = [
      Tile('New file', Icons.insert_drive_file_rounded, '', () async {
        final dest = await getInput(parent.path, 'Name');
        final newNode = BlobNode(parent: parent, path: dest);
        await newNode.store.call();
        Navigator.of(context).pop();
      }),
      Tile('New folder', Icons.create_new_folder_rounded, '', () async {
        final dest = await getInput(parent.path, 'Name, end with /');
        if (!dest.endsWith('/')) {
          showSnack('Must end with /', false);
        } else {
          final newNode = BlobNode(parent: parent, path: '$dest.blank');
          await newNode.store.call();
          Navigator.of(context).pop();
        }
      }),
      Tile('Existing Files', Icons.description_rounded, '', () async {
        final result = await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result == null) return;
        await parent.uploadFiles(result.paths).call();
        showSnack('Done', true);
      }),
      Tile('Existing Folder', Icons.folder_rounded, '', () async {
        final folderPath = await FilePicker.platform.getDirectoryPath();
        showSnack('Not implemented', false); //TODO
        if (folderPath == null) return;
        //print(await listAllSubEntities(folderPath));
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
