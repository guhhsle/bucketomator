import 'group.dart';
import 'blob.dart';
import 'sub.dart';
import '../../pages/nodes/subgroup.dart';
import '../../template/functions.dart';
import '../transfer.dart';

abstract class SubGroupNode extends SubNode with GroupNode {
  SubGroupNode({required super.path, super.parent, super.fsEntity});

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
    cache.refreshSubGroupSync(this);
    for (final node in shownNodes) {
      collected.add(node);
      if (node is SubGroupNode) node.addCachedNodesTo(collected);
    }
  }

  @override
  void open() {
    casuallyRefresh();
    goToPage(SubGroupNodePage(node: this));
  }
}
