import 'package:flutter/material.dart';
import 'blob.dart';
import '../../services/nodes/group.dart';
import '../../template/data.dart';

class BlobNodesPage extends StatefulWidget {
  final GroupNode group;
  final int initialIndex;
  const BlobNodesPage({
    super.key,
    required this.group,
    required this.initialIndex,
  });

  @override
  State<BlobNodesPage> createState() => _BlobNodesPageState();
}

class _BlobNodesPageState extends State<BlobNodesPage> {
  late PageController pageController;
  late GroupNode group;

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
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: bouncePhysics,
      children: group.shownBlobs.map((blob) {
        return BlobNodePage(blobNode: blob);
      }).toList(),
    );
  }
}
