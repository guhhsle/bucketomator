import 'package:flutter/material.dart';
import 'package:minio/minio.dart';
import '../template/functions.dart';
import '../data.dart';
import 'sbucket.dart';

class Storage with ChangeNotifier {
  static final instance = Storage.internal();
  late final Minio minio;
  List<Sbucket> sbuckets = [];

  factory Storage() => instance;

  Storage.internal();

  void init() async {
    try {
      minio = Minio(
        endPoint: Pref.endPoint.value,
        accessKey: Pref.accessKey.value,
        secretKey: Pref.secretKey.value,
      );
      final result = await minio.listBuckets();
      sbuckets = result.map((b) => Sbucket.fromBucket(b)).toList();
      notifyListeners();
    } catch (e) {
      showSnack('$e', false);
    }
  }
}
