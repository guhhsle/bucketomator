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
  void dispose() {
    subobject.textData = textController.text;
    subobject.update();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return SubobjectSheet(
      subobject: subobject,
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
