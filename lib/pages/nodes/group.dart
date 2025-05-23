import 'package:flutter/material.dart';
import '../../template/widget/frame.dart';
import '../../services/nodes/group.dart';
import '../../template/class/prefs.dart';
import '../../template/functions.dart';
import '../../widgets/node_list.dart';
import '../../layers/nodes/add.dart';
import '../../widgets/loading.dart';
import '../../layers/menu.dart';

class GroupNodePage extends StatelessWidget {
  final GroupNode groupNode;
  const GroupNodePage({super.key, required this.groupNode});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([groupNode, Preferences()]),
      builder: (context, child) => Frame(
        title: Text(groupNode.displayName),
        actions: [
          LoadingCircle(
            node: groupNode,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => AddNodeLayer(parent: groupNode).show(),
          ),
          IconButton(
            tooltip: t('Settings'),
            icon: const Icon(Icons.menu_rounded),
            onPressed: MenuLayer(storage: groupNode.storage).show,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => groupNode.remotelyRefresh(),
          child: NodeList(nodes: groupNode.shownNodes),
        ),
      ),
    );
  }
}
