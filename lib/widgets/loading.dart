import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  final bool show;
  const LoadingCircle({super.key, required this.show});

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
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
    );
  }
}
