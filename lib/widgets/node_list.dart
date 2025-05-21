import 'package:flutter/material.dart';
import '../services/nodes/sub.dart';
import '../template/data.dart';

class NodeList extends StatelessWidget {
  final List<SubNode> nodes;
  const NodeList({super.key, required this.nodes});

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Icon(Icons.deselect_rounded, size: 64),
        ),
      );
    } else {
      return ListView.builder(
        physics: bouncePhysics,
        itemCount: nodes.length,
        padding: EdgeInsets.only(top: 16, bottom: 32),
        itemBuilder: (context, i) => nodes[i].toWidget,
      );
    }
  }
}
