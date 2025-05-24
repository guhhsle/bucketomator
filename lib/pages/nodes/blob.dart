import 'package:flutter/material.dart';
import '../../template/widget/frame.dart';
import '../../services/nodes/blob.dart';
import '../../layers/nodes/blob.dart';
import '../../widgets/loading.dart';

class BlobNodePage extends StatelessWidget {
  final BlobNode blobNode;

  const BlobNodePage({super.key, required this.blobNode});

  @override
  Widget build(BuildContext c) {
    return ListenableBuilder(
      listenable: blobNode,
      builder: (context, child) => Frame(
        title: Text(blobNode.name),
        actions: [
          LoadingCircle(
            node: blobNode,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          IconButton(
            icon: Icon(Icons.save_rounded),
            tooltip: 'Save and exit',
            onPressed: () async {
              await blobNode.saveChanges();
              // ignore: use_build_context_synchronously
              Navigator.of(c).pop();
            },
          ),
          IconButton(
            icon: Icon(Icons.menu_rounded),
            tooltip: 'Menu',
            onPressed: () => BlobNodeLayer(node: blobNode).show(),
          ),
        ],
        child: blobNode.subWidget(scrollController: ScrollController()),
      ),
    );
  }
}
