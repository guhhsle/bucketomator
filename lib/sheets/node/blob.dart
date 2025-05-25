import 'package:flutter/material.dart';
import '../../template/widget/tile_card.dart';
import '../../services/nodes/blob.dart';
import '../../template/class/tile.dart';
import '../../layers/nodes/blob.dart';
import '../../widgets/loading.dart';

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
  @override
  void initState() {
    widget.blobNode.casuallyRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    double bottom = MediaQuery.of(c).viewInsets.vertical;
    if (bottom > 16) bottom -= 16;
    return ListenableBuilder(
      listenable: widget.blobNode,
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
                          Tile(
                            widget.blobNode.name,
                            Icons.save_rounded,
                            '',
                            () async {
                              await widget.blobNode.saveChanges();
                              // ignore: use_build_context_synchronously
                              Navigator.of(c).pop();
                            },
                          ),
                        ),
                      ),
                      LoadingCircle(node: widget.blobNode),
                      IconButton(
                        icon: Icon(Icons.menu_rounded),
                        onPressed: () =>
                            BlobNodeLayer(node: widget.blobNode).show(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: widget.blobNode.subWidget(
                      scrollController: widget.scrollController,
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
