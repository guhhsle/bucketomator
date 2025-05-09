import 'package:flutter/material.dart';
import 'blob_node.dart';
import '../services/nodes/blob.dart';

class ImageNodeSheet extends StatefulWidget {
  final BlobNode blobNode;
  const ImageNodeSheet({super.key, required this.blobNode});

  @override
  State<ImageNodeSheet> createState() => _ImageNodeSheetState();
}

class _ImageNodeSheetState extends State<ImageNodeSheet> {
  late BlobNode blobNode;

  @override
  void initState() {
    blobNode = widget.blobNode;
    blobNode.refresh().then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return BlobNodeSheet(
      blobNode: blobNode,
      child: Builder(
        builder: (context) {
          if (blobNode.data == null) return Container();
          return InteractiveViewer(
            child: Image.memory(blobNode.data!, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
