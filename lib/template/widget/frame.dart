import 'package:flutter/material.dart';

class Frame extends StatelessWidget {
  final bool automaticallyImplyLeading;
  final Widget? floatingActionButton, leading;
  final List<Widget> actions;
  final Widget? child;
  final Widget title;

  const Frame({
    super.key,
    this.automaticallyImplyLeading = true,
    this.title = const SizedBox(),
    this.floatingActionButton,
    this.actions = const [],
    this.leading,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [...actions, const SizedBox(width: 8)],
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32),
            topLeft: Radius.circular(16),
          ),
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            margin: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(),
            child: ClipRRect(child: child),
          ),
        ),
      ),
    );
  }
}
