import 'package:flutter/material.dart';
import 'package:minio/minio.dart';
import 'folder.dart';
import '../data.dart';

class Storage with ChangeNotifier {
  static final instance = Storage.internal();
  final root = Folder();

  factory Storage() => instance;
  Storage.internal();

  Minio get minio {
    return Minio(
      endPoint: Pref.endPoint.value,
      accessKey: Pref.accessKey.value,
      secretKey: Pref.secretKey.value,
    );
  }
}
