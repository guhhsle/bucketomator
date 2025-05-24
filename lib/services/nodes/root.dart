import 'loadable.dart';
import 'bucket.dart';
import 'group.dart';
import 'sub.dart';
import '../transfer.dart';
import '../storage/substorage.dart';

class RootNode extends LoadableNode with GroupNode {
  SubStorage subStorage;
  List<SubNode> cachedNodes = [];

  RootNode({required this.subStorage});

  Transfer createBucket(String name) => Transfer(
    'Creating bucket $name',
    future: () async {
      await storage.createBucket(name);
      await remotelyRefresh();
    }.call(),
  );

  void refreshCachedNodes() {
    storage.cache.refreshRootSync(this);

    cachedNodes = [];
    for (final node in subnodes) {
      node as BucketNode;
      cachedNodes.add(node);
      node.addCachedNodesTo(cachedNodes);
    }
    cachedNodes.sort((a, b) => a.fullPath.compareTo(b.fullPath));
    notifyListeners();
  }
}
