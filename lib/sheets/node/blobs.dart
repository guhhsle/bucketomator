import 'package:flutter/material.dart';
import 'blob.dart';
import '../../services/nodes/group.dart';
import '../../template/data.dart';

class BlobNodesSheet extends StatefulWidget {
  final GroupNode group;
  final int initialIndex;
  const BlobNodesSheet({
    super.key,
    required this.group,
    required this.initialIndex,
  });

  @override
  State<BlobNodesSheet> createState() => _BlobNodesSheetState();
}

class _BlobNodesSheetState extends State<BlobNodesSheet> {
  late GroupNode group;
  late PageController pageController;

  @override
  void initState() {
    group = widget.group;
    pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return Semantics(
      label: 'Bottom sheet',
      child: GestureDetector(
        onTap: () => Navigator.of(c).pop(),
        child: Container(
          color: Colors.transparent,
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.2,
            builder: (c, controller) => Card(
              elevation: 6,
              margin: const EdgeInsets.all(8),
              color: Theme.of(c).colorScheme.surface.withValues(alpha: 0.8),
              child: PageView(
                controller: pageController,
                physics: scrollPhysics,
                children: group.shownBlobs.map((blob) {
                  return BlobNodeSheet(
                    scrollController: controller,
                    blobNode: blob,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
