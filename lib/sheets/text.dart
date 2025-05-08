// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../services/subobject.dart';
import 'subobject.dart';

class TextObject extends StatefulWidget {
  final Subobject subobject;
  const TextObject({super.key, required this.subobject});

  @override
  State<TextObject> createState() => _TextObjectState();
}

class _TextObjectState extends State<TextObject> {
  final focusNode = FocusNode();
  late TextEditingController textController;
  late Subobject subobject;

  @override
  void initState() {
    subobject = widget.subobject;
    textController = TextEditingController(text: 'Loading');
    subobject.refresh().then((_) {
      textController.text = subobject.textData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return SubobjectSheet(
      subobject: subobject,
      trailing: [
        IconButton(
          icon: Icon(Icons.check_rounded),
          onPressed: () async {
            subobject.textData = textController.text;
            await subobject.update();
            Navigator.of(context).pop();
          },
        ),
      ],
      child: TextFormField(
        maxLines: null,
        controller: textController,
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
      ),
    );
  }
}
