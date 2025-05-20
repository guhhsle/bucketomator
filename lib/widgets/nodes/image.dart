import 'package:flutter/material.dart';
import '../../services/nodes/blob.dart';

class ImageNodeWidget extends StatelessWidget {
  final BlobNode blobNode;
  const ImageNodeWidget({super.key, required this.blobNode});

  @override
  Widget build(BuildContext context) {
    if (blobNode.data.isEmpty) return Container();
    return InteractiveViewer(child: Image.memory(blobNode.data));
  }
}
