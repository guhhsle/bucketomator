import 'package:flutter/material.dart';
import 'services/storage.dart';
import 'template/prefs.dart';
import 'template/app.dart';
import 'pages/folder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  runApp(
    App(
      title: 'S3',
      child: FolderPage(folder: Storage().root),
    ),
  );
}
