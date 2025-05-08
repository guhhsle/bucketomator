import 'package:flutter/material.dart';
import '../../template/functions.dart';
import '../../template/settings.dart';
import '../../widgets/frame.dart';
import '../services/folder.dart';
import '../template/data.dart';

class FolderPage extends StatefulWidget {
  final Folder folder;
  const FolderPage({super.key, required this.folder});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late Folder folder;
  @override
  void initState() {
    folder = widget.folder;
    folder.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: folder,
      builder: (context, child) => Frame(
        title: Text(folder.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => widget.folder.refresh(),
          ),
          IconButton(
            tooltip: t('Settings'),
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => goToPage(const PageSettings()),
          ),
        ],
        child: ListView.builder(
          physics: scrollPhysics,
          itemCount: folder.storageItems.length,
          itemBuilder: (context, i) => folder.storageItems[i].toWidget,
        ),
      ),
    );
  }
}
