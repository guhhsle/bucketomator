import 'loadable.dart';
import 'subgroup.dart';
import 'blob.dart';
import 'sub.dart';
import '../../data.dart';

mixin GroupNode on LoadableNode {
  List<SubNode> _subnodes = [];

  List<SubNode> get subnodes => _subnodes;
  set subnodes(List<SubNode> list) {
    _subnodes = list;
    notifyListeners();
  }

  @override
  bool get isEmpty => subnodes.isEmpty;

  List<SubGroupNode> get groups => subnodes.whereType<SubGroupNode>().toList();
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
    final shownGroups = shown.whereType<SubGroupNode>();
    final shownBlobs = shown.whereType<BlobNode>();

    if (Pref.prefixFirst.value) {
      return [...shownGroups, ...shownBlobs];
    } else {
      return [...shownBlobs, ...shownGroups];
    }
  }
}
