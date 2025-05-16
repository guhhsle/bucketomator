import 'package:flutter/material.dart';
import '../services/nodes/blob.dart';

class ImageNodeSheet extends StatelessWidget {
  final BlobNode blobNode;
  const ImageNodeSheet({super.key, required this.blobNode});

  @override
  Widget build(BuildContext c) {
    return InteractiveViewer(
      child: Image.memory(blobNode.data, fit: BoxFit.cover),
    );
  }
}
