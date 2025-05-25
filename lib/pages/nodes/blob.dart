import 'package:flutter/material.dart';
import '../../template/widget/frame.dart';
import '../../services/nodes/blob.dart';
import '../../layers/nodes/blob.dart';
import '../../widgets/loading.dart';

class BlobNodePage extends StatefulWidget {
  final BlobNode blobNode;

  const BlobNodePage({super.key, required this.blobNode});

  @override
  State<BlobNodePage> createState() => _BlobNodePageState();
}

class _BlobNodePageState extends State<BlobNodePage> {
  @override
  void initState() {
    widget.blobNode.casuallyRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return ListenableBuilder(
      listenable: widget.blobNode,
      builder: (context, child) => Frame(
        title: Text(widget.blobNode.name),
        actions: [
          LoadingCircle(
            node: widget.blobNode,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          IconButton(
            icon: Icon(Icons.save_rounded),
            tooltip: 'Save and exit',
            onPressed: widget.blobNode.saveChanges,
          ),
          IconButton(
            icon: Icon(Icons.menu_rounded),
            tooltip: 'Menu',
            onPressed: () => BlobNodeLayer(node: widget.blobNode).show(),
          ),
        ],
        child: widget.blobNode.subWidget(scrollController: ScrollController()),
      ),
    );
  }
}
