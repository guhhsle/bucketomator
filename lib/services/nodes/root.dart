import 'loadable.dart';
import 'bucket.dart';
import 'sub.dart';
import '../transfers/transfer.dart';
import '../storage/substorage.dart';

class RootNode extends LoadableNode {
  SubStorage subStorage;
  List<BucketNode> _buckets = [];
  List<SubNode> cachedNodes = [];

  List<BucketNode> get buckets => _buckets;
  set buckets(List<BucketNode> list) {
    _buckets = list..sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

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
    for (final node in buckets) {
      cachedNodes.add(node);
      node.addCachedNodesTo(cachedNodes);
    }
    cachedNodes.sort((a, b) => a.fullPath.compareTo(b.fullPath));
    notifyListeners();
  }
}
