import 'package:flutter/material.dart';
import '../../template/functions.dart';
import '../services/nodes/group.dart';
import '../template/prefs.dart';
import '../widgets/node_list.dart';
import '../layers/nodes/add.dart';
import '../../widgets/frame.dart';
import '../widgets/loading.dart';
import '../layers/menu.dart';

class GroupNodePage extends StatefulWidget {
  final GroupNode groupNode;
  const GroupNodePage({super.key, required this.groupNode});

  @override
  State<GroupNodePage> createState() => _GroupNodePageState();
}

class _GroupNodePageState extends State<GroupNodePage> {
  late GroupNode groupNode;
  @override
  void initState() {
    groupNode = widget.groupNode;
    groupNode.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([groupNode, Preferences()]),
      builder: (context, child) => Frame(
        title: Text(groupNode.displayName),
        actions: [
          LoadingCircle(show: !groupNode.loaded),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => AddNodeLayer(parent: groupNode).show(),
          ),
          IconButton(
            tooltip: t('Settings'),
            icon: const Icon(Icons.menu_rounded),
            onPressed: MenuLayer().show,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: groupNode.refresh,
          child: NodeList(
            nodes: groupNode.shownNodes,
            loaded: groupNode.loaded,
          ),
        ),
      ),
    );
  }
}
