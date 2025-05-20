import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../services/nodes/blob.dart';

class PDFNodeWidget extends StatelessWidget {
  final BlobNode blobNode;
  const PDFNodeWidget({super.key, required this.blobNode});

  @override
  Widget build(BuildContext context) {
    if (blobNode.data.isEmpty) return Container();
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: constraints.maxHeight,
        child: PdfViewer.data(blobNode.data, sourceName: blobNode.name),
      ),
    );
  }
}
