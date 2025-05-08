import 'package:flutter/material.dart';
import '../services/subobject.dart';
import 'subobject.dart';

class ImageObject extends StatefulWidget {
  final Subobject subobject;
  const ImageObject({super.key, required this.subobject});

  @override
  State<ImageObject> createState() => _ImageObjectState();
}

class _ImageObjectState extends State<ImageObject> {
  late Subobject subobject;

  @override
  void initState() {
    subobject = widget.subobject;
    subobject.refresh().then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return SubobjectSheet(
      subobject: subobject,
      child: Builder(
        builder: (context) {
          if (subobject.data == null) return Container();
          return InteractiveViewer(
            child: Image.memory(subobject.data!, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
