import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  final bool show;
  final Color? color;
  const LoadingCircle({super.key, required this.show, this.color});

  @override
  Widget build(BuildContext context) {
    if (!show) return Container();
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
  }
}
