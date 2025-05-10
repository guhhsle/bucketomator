import '../../data.dart';
import '../../template/functions.dart';
import '../endpoint.dart';
import 'blob.dart';
import 'node.dart';

abstract class GroupNode extends Node {
  List<Node> nodes = [];

  GroupNode({required super.path, super.parent});

  List<GroupNode> get groups => nodes.whereType<GroupNode>().toList();
  List<BlobNode> get blobs => nodes.whereType<BlobNode>().toList();

  List<Node> get shownNodes {
    List<Node> shown = nodes.toList();
    if (Pref.nodeSort.value.startsWith('Name')) {
      shown.sort((a, b) => a.name.compareTo(b.name));
    } else if (Pref.nodeSort.value.startsWith('Date')) {
      shown.sort((a, b) {
        if (a.date == null && b.date == null) return a.name.compareTo(b.name);
        if (a.date == null) return 1;
        if (b.date == null) return -1;
        return a.date!.compareTo(b.date!);
      });
    } else if (Pref.nodeSort.value.startsWith('Size')) {
      shown.sort((a, b) {
        if (a.size == null && b.date == null) return a.name.compareTo(b.name);
        if (a.size == null) return 1;
        if (b.size == null) return -1;
        return a.size!.compareTo(b.size!);
      });
    }
    if (Pref.nodeSort.value.endsWith('Desc')) {
      shown = nodes.reversed.toList();
    }
    final shownGroups = shown.whereType<GroupNode>().toList();
    final shownBlobs = shown.whereType<BlobNode>().toList();

    if (Pref.prefixFirst.value) {
      return [...shownGroups, ...shownBlobs];
    } else {
      return [...shownBlobs, ...shownGroups];
    }
  }

  @override
  Future<void> refresh() async {
    loaded = false;
    notifyListeners();
    nodes = await EndPoint().listNodes(this);
    loaded = true;
    notifyListeners();
  }

  Future<void> uploadFiles(List<String?> files) async {
    await EndPoint().uploadPaths(this, files);
    refresh();
  }

  Future<List<BlobNode>> addSubBlobNodesTo(
    List<BlobNode> collected, {
    bool alert = true,
  }) async {
    await refresh();
    if (alert) showSnack('Removing $path', false);
    collected.addAll(blobs);
    List<Future> futures = [];
    for (final group in groups) {
      futures.add(group.addSubBlobNodesTo(collected));
    }
    await Future.wait(futures);
    return collected;
  }
}
