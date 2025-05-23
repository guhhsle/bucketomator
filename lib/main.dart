import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'template/class/prefs.dart';
import 'template/widget/app.dart';
import 'services/profile.dart';
import 'pages/root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  if (Pref.cachePath.value == '') {
    Pref.cachePath.set((await getApplicationCacheDirectory()).path);
  }
  Profile.initCache();
  Profile.current.subStorage.root.casuallyRefresh();
  runApp(const App(title: 'Bucketomator', child: RootPage()));
}
