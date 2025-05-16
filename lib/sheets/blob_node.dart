import 'package:flutter/material.dart';
import '../services/nodes/blob.dart';
import '../services/nodes/group.dart';
import '../template/tile_card.dart';
import '../template/data.dart';
import '../template/tile.dart';
import '../widgets/loading.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await blobNode.refresh();
      setState(() {});
    });
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
                      LoadingCircle(show: !blobNode.loaded),
                      IconButton(
                        icon: Icon(Icons.file_download_rounded),
                        onPressed: () => blobNode.download.call(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: widget.scrollController,
                      physics: scrollPhysics,
                      padding: EdgeInsets.only(bottom: 64, left: 4, right: 4),
                      child: blobNode.hasData ? blobNode.subSheet : Container(),
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

class GroupNodePageSheet extends StatefulWidget {
  final GroupNode group;
  final int initialIndex;
  const GroupNodePageSheet({
    super.key,
    required this.group,
    required this.initialIndex,
  });

  @override
  State<GroupNodePageSheet> createState() => _GroupNodePageSheetState();
}

class _GroupNodePageSheetState extends State<GroupNodePageSheet> {
  int index = 0;
  late GroupNode group;
  late PageController pageController;

  @override
  void initState() {
    index = widget.initialIndex;
    group = widget.group;
    pageController = PageController(initialPage: index, viewportFraction: 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Bottom sheet',
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        builder: (c, controller) => Card(
          elevation: 6,
          margin: const EdgeInsets.all(8),
          color: Theme.of(c).colorScheme.surface.withValues(alpha: 0.8),
          child: PageView(
            controller: pageController,
            children: group.blobs.map((blob) {
              return BlobNodeSheet(
                scrollController: controller,
                blobNode: blob,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
