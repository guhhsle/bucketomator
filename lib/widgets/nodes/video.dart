import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import '../../services/nodes/blob.dart';

class VideoNodeWidget extends StatefulWidget {
  final BlobNode blobNode;
  const VideoNodeWidget({super.key, required this.blobNode});

  @override
  State<VideoNodeWidget> createState() => _VideoNodeWidgetState();
}

class _VideoNodeWidgetState extends State<VideoNodeWidget> {
  VideoPlayerController? controller;

  @override
  void initState() {
    widget.blobNode.addListener(() async {
      if (controller == null && widget.blobNode.data.isNotEmpty) {
        final file = await widget.blobNode.storeTemporarily();
        final controller = VideoPlayerController.file(file);
        await controller.initialize();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) return Container();
    if (!controller!.value.isInitialized) return Container();
    return VideoPlayer(controller!);
  }
}
