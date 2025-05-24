import 'package:flutter/material.dart';
import '../../services/nodes/blob.dart';

class ImageNodeWidget extends StatelessWidget {
  final BlobNode blobNode;
  const ImageNodeWidget({super.key, required this.blobNode});

  @override
  Widget build(BuildContext context) {
    if (blobNode.data.isEmpty) return Container();
    return InteractiveViewer(
      maxScale: 4,
      minScale: 0.2,
      child: Image.memory(blobNode.data),
    );
  }
}
