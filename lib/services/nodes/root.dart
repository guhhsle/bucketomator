import 'package:s3/services/nodes/loadable.dart';
import 'bucket.dart';
import 'sub.dart';
import '../transfers/transfer.dart';
import '../storage/storage.dart';
import '../storage/cache.dart';

class RootNode extends LoadableNode {
  List<BucketNode> _buckets = [];
  List<SubNode> cachedNodes = [];

  List<BucketNode> get buckets => _buckets;

  set buckets(List<BucketNode> list) {
    _buckets = list..sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  @override
  Future<void> refresh(bool force) => Storage().refreshRoot(this, force);

  Transfer createBucket(String name) => Transfer(
    'Creating bucket $name',
    future: () async {
      await Storage().createBucket(name);
      await refresh(true);
    }.call(),
  );

  void refreshCachedNodes() {
    Cache().refreshRootSync(this);

    cachedNodes = [];
    for (final node in buckets) {
      cachedNodes.add(node);
      node.addCachedNodesTo(cachedNodes);
    }
    cachedNodes.sort((a, b) => a.fullPath.compareTo(b.fullPath));
    notifyListeners();
  }
}
