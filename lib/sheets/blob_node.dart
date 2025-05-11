import 'package:flutter/material.dart';
import '../services/nodes/blob.dart';
import '../template/tile_card.dart';
import '../template/data.dart';
import '../template/tile.dart';
import '../widgets/loading.dart';

class BlobNodeSheet extends StatelessWidget {
  final BlobNode blobNode;
  final Widget child;
  final void Function()? onSave;

  const BlobNodeSheet({
    super.key,
    required this.blobNode,
    required this.child,
    this.onSave,
  });

  @override
  Widget build(BuildContext c) {
    double bottom = MediaQuery.of(c).viewInsets.vertical;
    if (bottom > 16) bottom -= 16;
    return Semantics(
      label: 'Bottom sheet',
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        builder: (c, controller) => ListenableBuilder(
          listenable: blobNode,
          builder: (c, snapshot) => Card(
            elevation: 6,
            margin: const EdgeInsets.all(8),
            color: Theme.of(c).colorScheme.surface.withValues(alpha: 0.8),
            child: Container(
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
                                  blobNode.name,
                                  Icons.save_rounded,
                                  '',
                                  () async {
                                    if (onSave == null) return;
                                    onSave?.call();
                                    await blobNode.update();
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(c).pop();
                                  },
                                ),
                              ),
                            ),
                            LoadingCircle(show: !blobNode.loaded),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            physics: scrollPhysics,
                            padding: EdgeInsets.only(
                              bottom: 64,
                              left: 4,
                              right: 4,
                            ),
                            child: blobNode.data.isEmpty ? null : child,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
