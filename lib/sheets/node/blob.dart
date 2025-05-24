import 'package:flutter/material.dart';
import '../../template/widget/tile_card.dart';
import '../../services/nodes/blob.dart';
import '../../template/class/tile.dart';
import '../../layers/nodes/blob.dart';
import '../../widgets/loading.dart';

class BlobNodeSheet extends StatelessWidget {
  final BlobNode blobNode;
  final ScrollController scrollController;

  const BlobNodeSheet({
    super.key,
    required this.scrollController,
    required this.blobNode,
  });

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
                            await blobNode.saveChanges();
                            // ignore: use_build_context_synchronously
                            Navigator.of(c).pop();
                          }),
                        ),
                      ),
                      LoadingCircle(node: blobNode),
                      IconButton(
                        icon: Icon(Icons.menu_rounded),
                        onPressed: () => BlobNodeLayer(node: blobNode).show(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: blobNode.subWidget(
                      scrollController: scrollController,
                    ),
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
