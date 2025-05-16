import 'package:flutter/material.dart';
import '../../template/functions.dart';
import '../services/nodes/root.dart';
import '../services/endpoint.dart';
import '../widgets/node_list.dart';
import '../../widgets/frame.dart';
import '../layers/profiles.dart';
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
        title: Text(EndPoint().profile.name),
        actions: [
          LoadingCircle(
            show: !root.loaded,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => getInput('', 'Bucket Name').then((name) {
              root.createBucket(name).call();
            }),
          ),
          IconButton(
            icon: Icon(Icons.person_rounded),
            onPressed: () => ProfilesLayer().show(),
          ),
          IconButton(
            tooltip: t('Settings'),
            icon: const Icon(Icons.menu_rounded),
            onPressed: MenuLayer().show,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: root.refresh,
          child: NodeList(nodes: root.buckets, loaded: root.loaded),
        ),
      ),
    );
  }
}
