import '../endpoint.dart';
import 'blob.dart';
import 'node.dart';

abstract class GroupNode extends Node {
  List<Node> nodes = [];

  GroupNode({required super.path, super.parent});

  List<GroupNode> get groups => nodes.whereType<GroupNode>().toList();
  List<BlobNode> get blobs => nodes.whereType<BlobNode>().toList();

  @override
  Future<void> refresh() async {
    loaded = false;
    nodes = await EndPoint().listNodes(this);
    loaded = true;
    notifyListeners();
  }
}
