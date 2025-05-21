import 'package:flutter/material.dart';
import '../services/storage/storage.dart';
import '../../template/functions.dart';
import '../template/widget/frame.dart';
import '../widgets/node_list.dart';
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
    Storage().root.refresh(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final root = Storage().root;
    return ListenableBuilder(
      listenable: root,
      builder: (context, child) => Frame(
        title: Text(Storage().profile.name),
        actions: [
          LoadingCircle(
            node: root,
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
          onRefresh: () => root.refresh(true),
          child: NodeList(nodes: root.buckets),
        ),
      ),
    );
  }
}
