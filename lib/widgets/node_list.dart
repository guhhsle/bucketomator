import 'package:flutter/material.dart';
import 'nodes/subnode.dart';
import '../template/class/prefs.dart';
import '../services/nodes/sub.dart';
import '../template/data.dart';
import '../data.dart';

class NodeList extends StatelessWidget {
  final List<SubNode> nodes;
  const NodeList({super.key, required this.nodes});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Preferences(),
      builder: (context, child) {
        if (Pref.gridCount.value == 1) {
          return ListView.builder(
            physics: bouncePhysics,
            itemCount: nodes.length,
            padding: EdgeInsets.only(top: 16, bottom: 32),
            itemBuilder: (context, i) => nodes[i].toTile.toWidget,
          );
        } else {
          return ListenableBuilder(
            listenable: Preferences(),
            builder: (context, child) => GridView.builder(
              physics: bouncePhysics,
              itemCount: nodes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Pref.gridCount.value,
                mainAxisExtent: 128,
              ),
              padding: EdgeInsets.only(top: 16, bottom: 32),
              itemBuilder: (context, i) => SubNodeWidget(node: nodes[i]),
            ),
          );
        }
      },
    );
  }
}
