import 'package:flutter/material.dart';
import '../../services/nodes/subgroup.dart';
import '../../template/widget/frame.dart';
import '../../template/class/prefs.dart';
import '../../template/functions.dart';
import '../../widgets/node_list.dart';
import '../../layers/nodes/add.dart';
import '../../widgets/loading.dart';
import '../../layers/menu.dart';

class SubGroupNodePage extends StatelessWidget {
  final SubGroupNode node;
  const SubGroupNodePage({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([node, Preferences()]),
      builder: (context, child) => Frame(
        title: Text(node.displayName),
        actions: [
          LoadingCircle(
            node: node,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => AddNodeLayer(parent: node).show(),
          ),
          IconButton(
            tooltip: t('Settings'),
            icon: const Icon(Icons.menu_rounded),
            onPressed: MenuLayer(storage: node.storage).show,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => node.remotelyRefresh(),
          child: NodeList(nodes: node.shownNodes),
        ),
      ),
    );
  }
}
