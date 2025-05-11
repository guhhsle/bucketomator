// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'blob_node.dart';
import '../services/nodes/blob.dart';

class TextNodeSheet extends StatefulWidget {
  final BlobNode blobNode;
  const TextNodeSheet({super.key, required this.blobNode});

  @override
  State<TextNodeSheet> createState() => _TextNodeSheetState();
}

class _TextNodeSheetState extends State<TextNodeSheet> {
  final focusNode = FocusNode();
  late TextEditingController textController;
  late BlobNode blobNode;

  @override
  void initState() {
    blobNode = widget.blobNode;
    textController = TextEditingController(text: 'Loading');
    blobNode.refresh().then((_) {
      textController.text = blobNode.textData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return BlobNodeSheet(
      blobNode: blobNode,
      trailing: [
        IconButton(
          icon: Icon(Icons.save_rounded),
          onPressed: () async {
            blobNode.textData = textController.text;
            await blobNode.update();
            Navigator.of(context).pop();
          },
        ),
      ],
      child: TextFormField(
        maxLines: null,
        controller: textController,
        focusNode: focusNode,
        style: Theme.of(c).textTheme.bodySmall!,
        cursorColor: Theme.of(c).colorScheme.primary,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
