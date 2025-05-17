import 'package:flutter/material.dart';
import '../services/nodes/blob.dart';

class TextNodeSheet extends StatefulWidget {
  final BlobNode blobNode;
  const TextNodeSheet({super.key, required this.blobNode});

  @override
  State<TextNodeSheet> createState() => _TextNodeSheetState();
}

class _TextNodeSheetState extends State<TextNodeSheet> {
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext c) {
    return TextFormField(
      maxLines: null,
      controller: widget.blobNode.textController,
      focusNode: focusNode,
      style: Theme.of(c).textTheme.bodyMedium!,
      cursorColor: Theme.of(c).colorScheme.primary,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
