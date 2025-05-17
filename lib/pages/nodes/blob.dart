import 'package:flutter/material.dart';
import '../../services/nodes/blob.dart';
import '../../layers/nodes/blob.dart';
import '../../widgets/loading.dart';
import '../../template/data.dart';
import '../../widgets/frame.dart';

class BlobNodePage extends StatefulWidget {
  final BlobNode blobNode;

  const BlobNodePage({super.key, required this.blobNode});

  @override
  State<BlobNodePage> createState() => _BlobNodePageState();
}

class _BlobNodePageState extends State<BlobNodePage> {
  late BlobNode blobNode;

  @override
  void initState() {
    blobNode = widget.blobNode;
    blobNode.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return ListenableBuilder(
      listenable: blobNode,
      builder: (context, child) {
        return Frame(
          title: Text(blobNode.name),
          actions: [
            LoadingCircle(
              show: !blobNode.loaded,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            IconButton(
              icon: Icon(Icons.save_rounded),
              onPressed: () async {
                await widget.blobNode.saveChanges();
                // ignore: use_build_context_synchronously
                Navigator.of(c).pop();
              },
            ),
            IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () => BlobNodeLayer(node: blobNode).show(),
            ),
          ],
          child: SingleChildScrollView(
            physics: scrollPhysics,
            padding: EdgeInsets.only(bottom: 64, left: 8, right: 8, top: 8),
            child: blobNode.subWidget,
          ),
        );
      },
    );
  }
}
