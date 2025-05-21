import 'package:flutter/material.dart';
import '../../template/widget/tile_card.dart';
import '../../services/nodes/blob.dart';
import '../../template/class/tile.dart';
import '../../widgets/loading.dart';
import '../../template/data.dart';

class BlobNodeSheet extends StatefulWidget {
  final BlobNode blobNode;
  final ScrollController scrollController;

  const BlobNodeSheet({
    super.key,
    required this.scrollController,
    required this.blobNode,
  });

  @override
  State<BlobNodeSheet> createState() => _BlobNodeSheetState();
}

class _BlobNodeSheetState extends State<BlobNodeSheet> {
  late BlobNode blobNode;

  @override
  void initState() {
    blobNode = widget.blobNode;
    blobNode.refresh(false);
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    double bottom = MediaQuery.of(c).viewInsets.vertical;
    if (bottom > 16) bottom -= 16;
    return ListenableBuilder(
      listenable: blobNode,
      builder: (context, cal) => Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TileCard(
                          Tile(blobNode.name, Icons.save_rounded, '', () async {
                            await widget.blobNode.saveChanges();
                            // ignore: use_build_context_synchronously
                            Navigator.of(c).pop();
                          }),
                        ),
                      ),
                      LoadingCircle(node: blobNode),
                      IconButton(
                        icon: Icon(Icons.file_download_rounded),
                        onPressed: () => blobNode.download.call(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: blobNode.blobType.isFixedHeight
                        ? SingleChildScrollView(
                            physics: bouncePhysics,
                            padding: EdgeInsets.only(
                              bottom: 64,
                              left: 8,
                              right: 8,
                              top: 16,
                            ),
                            child: blobNode.subWidget,
                          )
                        : blobNode.subWidget,
                  ),
                ],
              ),
            ),
            SizedBox(height: bottom),
          ],
        ),
      ),
    );
  }
}
