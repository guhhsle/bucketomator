import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/nodes/subgroup.dart';
import '../../template/class/layer.dart';
import '../../services/nodes/blob.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';

class AddNodeLayer extends Layer {
  SubGroupNode parent;

  AddNodeLayer({required this.parent});
  @override
  void construct() {
    action = Tile('Add new node', Icons.add_rounded);
    list = [
      Tile('New file', Icons.insert_drive_file_rounded, '', () async {
        Navigator.of(context).pop();
        final dest = await getInput(parent.path, 'Name');
        final newNode = BlobNode(parent: parent, path: dest);
        await newNode.store.call();
      }),
      Tile('New folder', Icons.create_new_folder_rounded, '', () async {
        Navigator.of(context).pop();
        String dest = await getInput(parent.path, 'Add folder path');
        if (!dest.endsWith('/')) dest += '/';

        final newNode = BlobNode(parent: parent, path: '$dest/blank');
        await newNode.store.call();
      }),
      Tile('Existing Files', Icons.description_rounded, '', () async {
        final result = await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result == null) return;
        await parent.uploadFiles(result.paths).call();
      }),
    ];
  }
}

/*

      Tile('Existing Folder', Icons.folder_rounded, '', () async {
        final folderPath = await FilePicker.platform.getDirectoryPath();
        showSnack('Not implemented', false); 
				//TODO implement
        if (folderPath == null) return;
        //print(await listAllSubEntities(folderPath));
        //await parent.uploadFiles(result.paths);
      }),
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
*/
