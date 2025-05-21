import 'package:flutter/material.dart';
import '../services/nodes/loadable.dart';
import '../data.dart';

class LoadingCircle extends StatelessWidget {
  final LoadableNode node;
  final Color? color;
  const LoadingCircle({super.key, required this.node, this.color});

  @override
  Widget build(BuildContext context) {
    if (node.serverStatus == Status.completed) {
      return Container();
    } else if (node.serverStatus == Status.inProgress) {
      return IconButton(
        onPressed: () {},
        icon: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.refresh_rounded),
        onPressed: () => node.refresh(true),
      );
    }
  }
}
