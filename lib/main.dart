import 'package:flutter/material.dart';
import 'template/prefs.dart';
import 'pages/root.dart';
import 'template/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  runApp(const App(title: 'S3', child: RootPage()));
}
