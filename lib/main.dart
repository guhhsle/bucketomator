import 'package:flutter/material.dart';
import 'template/class/prefs.dart';
import 'template/widget/app.dart';
import 'services/profile.dart';
import 'pages/root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  Profiles().init();
  runApp(const App(title: 'S3', child: RootPage()));
}
