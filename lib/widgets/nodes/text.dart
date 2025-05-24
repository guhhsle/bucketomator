import 'package:flutter/material.dart';
import '../../services/nodes/blob.dart';
import '../../template/data.dart';

class TextNodeWidget extends StatefulWidget {
  final BlobNode blobNode;
  final ScrollController scrollController;
  const TextNodeWidget({
    super.key,
    required this.blobNode,
    required this.scrollController,
  });

  @override
  State<TextNodeWidget> createState() => _TextNodeWidgetState();
}

class _TextNodeWidgetState extends State<TextNodeWidget> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext c) {
    return SingleChildScrollView(
      physics: bouncePhysics,
      controller: widget.scrollController,
      padding: EdgeInsets.only(bottom: 64, left: 8, right: 8),
      child: TextFormField(
        maxLines: null,
        controller: widget.blobNode.textController,
        focusNode: focusNode,
        style: Theme.of(c).textTheme.bodyMedium!,
        cursorColor: Theme.of(c).colorScheme.primary,
        showCursor: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'Text',
          hintStyle: Theme.of(c).textTheme.bodyMedium!.copyWith(
            color: Theme.of(c).colorScheme.primary.withAlpha(150),
          ),
        ),
      ),
    );
  }
}
