import 'package:flutter/material.dart';
import '../../services/nodes/sub.dart';

class SubNodeWidget extends StatelessWidget {
  final SubNode node;
  const SubNodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final tile = node.toTile;
    return InkWell(
      onTap: tile.onTap,
      onLongPress: tile.onHold,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Center(child: Icon(tile.icon, size: 48)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              tile.title,
              style: TextStyle(
                fontSize: 16,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
