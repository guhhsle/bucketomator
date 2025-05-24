import 'package:flutter/material.dart';
import '../../services/nodes/sub.dart';
import '../../template/functions.dart';
import '../../data.dart';

class SubNodeWidget extends StatelessWidget {
  final SubNode node;
  const SubNodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final tile = node.toTile;
    if (Pref.gridCount.value == 1) return tile.toWidget;
    return InkWell(
      onTap: tile.onTap,
      onLongPress: tile.onHold,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Center(child: Icon(tile.icon, size: 48)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(t(tile.title), style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
