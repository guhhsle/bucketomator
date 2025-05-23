import 'package:flutter/material.dart';
import '../../services/storage/substorage.dart';
import '../../template/class/layer.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';
import '../../services/nodes/sub.dart';

class AllCachedNodesLayer extends Layer {
  final SubStorage storage;
  String query = '';
  AllCachedNodesLayer({required this.storage}) {
    storage.root.refreshCachedNodes();
  }
  List<SubNode> get queriedCachedNodes {
    final results = <SubNode>[];
    for (final node in storage.root.cachedNodes) {
      if (node.fullPath.toLowerCase().contains(query.toLowerCase())) {
        results.add(node);
      }
    }
    return results;
  }

  @override
  void construct() {
    listenTo(storage);
    String actionName = 'Search cache';
    if (query.isNotEmpty) actionName = query;
    action = Tile(actionName, Icons.search_rounded, '', () async {
      query = await getInput(query, 'Search query');
      reconstruct();
    });
    list = queriedCachedNodes.map((node) {
      return node.toCacheTile;
    });
  }
}
