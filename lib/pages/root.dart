import 'package:flutter/material.dart';
import '../../template/functions.dart';
import '../services/nodes/root.dart';
import '../widgets/node_list.dart';
import '../../widgets/frame.dart';
import '../widgets/loading.dart';
import '../layers/menu.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    RootNode().refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final root = RootNode();
    return ListenableBuilder(
      listenable: root,
      builder: (context, child) => Frame(
        title: Text('S3'),
        actions: [
          LoadingCircle(show: !root.loaded),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => () {},
          ),
          IconButton(
            tooltip: t('Settings'),
            icon: const Icon(Icons.menu_rounded),
            onPressed: MenuLayer().show,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => root.refresh(),
          child: NodeList(nodes: root.buckets, loaded: root.loaded),
        ),
      ),
    );
  }
}
