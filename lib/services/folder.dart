import 'subfolder.dart';
import 'subobject.dart';
import 'storage.dart';
import '../template/functions.dart';
import '../services/subitem.dart';

class Folder extends StorageItem {
  List<Subfolder> subfolders = [];
  List<Subobject> subobjects = [];

  @override
  String get path => '/';

  @override
  Future<void> refresh() async {
    try {
      final buckets = await Storage().minio.listBuckets();
      subfolders = buckets.map((b) {
        return Subfolder(bucket: b, parent: this);
      }).toList();
      subfolders.sort((a, b) => a.bucket.name.compareTo(b.bucket.name));
      notifyListeners();
    } catch (e) {
      showSnack('$e', false);
    }
  }

  List<StorageItem> get storageItems {
    return [...subfolders, ...subobjects];
  }
}
