import 'package:flutter/material.dart';
import '../../services/nodes/blob.dart';

class TextNodeWidget extends StatefulWidget {
  final BlobNode blobNode;
  const TextNodeWidget({super.key, required this.blobNode});

  @override
  State<TextNodeWidget> createState() => _TextNodeWidgetState();
}

class _TextNodeWidgetState extends State<TextNodeWidget> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext c) {
    return TextFormField(
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
      ),
    );
  }
}
