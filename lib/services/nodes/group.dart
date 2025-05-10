import '../../data.dart';
import '../endpoint.dart';
import 'blob.dart';
import 'node.dart';

abstract class GroupNode extends Node {
  List<Node> nodes = [];

  GroupNode({required super.path, super.parent});

  List<GroupNode> get groups => nodes.whereType<GroupNode>().toList();
  List<BlobNode> get blobs => nodes.whereType<BlobNode>().toList();
  List<Node> get shownNodes {
    if (Pref.nodeSort.value.startsWith('Name')) {
      nodes.sort((a, b) => a.name.compareTo(b.name));
    } else if (Pref.nodeSort.value.startsWith('Date')) {
      nodes.sort((a, b) {
        if (a.date == null && b.date == null) return a.name.compareTo(b.name);
        if (a.date == null) return 1;
        if (b.date == null) return -1;
        return a.date!.compareTo(b.date!);
      });
    }
    //TODO add size
    if (Pref.nodeSort.value.endsWith('Desc')) {
      nodes = nodes.reversed.toList();
    }
    if (Pref.prefixFirst.value) {
      return [...groups, ...blobs];
    } else {
      return [...blobs, ...groups];
    }
  }

  @override
  Future<void> refresh() async {
    loaded = false;
    nodes = await EndPoint().listNodes(this);
    loaded = true;
    notifyListeners();
  }
}
