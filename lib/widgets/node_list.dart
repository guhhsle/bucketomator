import 'package:flutter/material.dart';

import '../services/nodes/node.dart';
import '../template/data.dart';

class NodeList extends StatelessWidget {
  final List<Node> nodes;
  final bool loaded;
  const NodeList({super.key, required this.nodes, required this.loaded});

  @override
  Widget build(BuildContext context) {
    if (loaded && nodes.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Icon(Icons.deselect_rounded, size: 64),
        ),
      );
    } else {
      return ListView.builder(
        physics: scrollPhysics,
        itemCount: nodes.length,
        padding: EdgeInsets.only(top: 16, bottom: 32),
        itemBuilder: (context, i) => nodes[i].toWidget,
      );
    }
  }
}
