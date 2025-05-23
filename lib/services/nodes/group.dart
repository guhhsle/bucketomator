import 'blob.dart';
import 'sub.dart';
import '../../template/functions.dart';
import '../../pages/nodes/group.dart';
import '../transfers/transfer.dart';
import '../../data.dart';

abstract class GroupNode extends SubNode {
  List<SubNode> _subnodes = [];

  GroupNode({required super.path, super.parent, super.fsEntity});

  List<SubNode> get subnodes => _subnodes;
  set subnodes(List<SubNode> list) {
    _subnodes = list;
    notifyListeners();
  }

  List<GroupNode> get groups => subnodes.whereType<GroupNode>().toList();
  List<BlobNode> get blobs => subnodes.whereType<BlobNode>().toList();

  List<SubNode> get shownNodes {
    List<SubNode> shown = subnodes.toList();
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
      shown = subnodes.reversed.toList();
    }
    if (!Pref.showHidden.value) {
      shown.removeWhere((node) => node.name.startsWith('.'));
    }
    final shownGroups = shown.whereType<GroupNode>().toList();
    final shownBlobs = shown.whereType<BlobNode>().toList();

    if (Pref.prefixFirst.value) {
      return [...shownGroups, ...shownBlobs];
    } else {
      return [...shownBlobs, ...shownGroups];
    }
  }

  List<BlobNode> get shownBlobs => shownNodes.whereType<BlobNode>().toList();

  Transfer uploadFiles(List<String?> files) => Transfer(
    'Uploading ${files.length} files',
    future: () async {
      await storage.uploadPaths(this, files);
      await remotelyRefresh();
    }.call(),
  );

  Transfer addSubBlobNodesTo(List<BlobNode> collected) => Transfer(
    'Collecting all subnodes in $name',
    future: () async {
      await remotelyRefresh();
      collected.addAll(blobs);
      List<Future> futures = [];
      for (final group in groups) {
        futures.add(group.addSubBlobNodesTo(collected).call());
      }
      await Future.wait(futures);
    }.call(),
  );

  Transfer removeNodes(List<BlobNode> collected) => Transfer(
    'Removing nodes in $name',
    future: storage.removeBlobNodes(collected),
  );

  void addCachedNodesTo(List<SubNode> collected) {
    cache.refreshGroupSync(this);
    for (final node in shownNodes) {
      collected.add(node);
      if (node is GroupNode) node.addCachedNodesTo(collected);
    }
  }

  @override
  void open() {
    casuallyRefresh();
    goToPage(GroupNodePage(groupNode: this));
  }
}
