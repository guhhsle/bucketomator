import 'package:flutter/material.dart';
import '../../template/functions.dart';
import '../template/widget/frame.dart';
import '../widgets/node_list.dart';
import '../services/profile.dart';
import '../layers/profiles.dart';
import '../widgets/loading.dart';
import '../layers/menu.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final root = Profile.current.subStorage.root;
    //Here because it should dynamically show only the current root
    return ListenableBuilder(
      listenable: root,
      builder: (context, child) => Frame(
        title: Text(root.storage.profile.name),
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
            onPressed: MenuLayer(storage: root.storage).show,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => root.remotelyRefresh(),
          child: NodeList(nodes: root.buckets),
        ),
      ),
    );
  }
}
