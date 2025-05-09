import 'package:flutter/material.dart';
import '../../template/functions.dart';
import '../../template/settings.dart';
import '../services/nodes/root.dart';
import '../../widgets/frame.dart';
import '../template/data.dart';
import '../widgets/node_list.dart';

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
    return ListenableBuilder(
      listenable: RootNode(),
      builder: (context, child) => Frame(
        title: Text('S3'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => () {},
          ),
          IconButton(
            tooltip: t('Settings'),
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => goToPage(const PageSettings()),
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => RootNode().refresh(),
          child: NodeList(nodes: RootNode().buckets, loaded: RootNode().loaded),
        ),
      ),
    );
  }
}
