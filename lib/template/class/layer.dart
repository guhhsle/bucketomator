import 'package:flutter/material.dart';
import 'prefs.dart';
import 'tile.dart';
import '../widget/visual_layer.dart';
import '../data.dart';

abstract class Layer extends ChangeNotifier {
  Iterable<Widget> leading = [], trailing = [];
  BuildContext? dirtyContext;
  Iterable<Tile> list = [];
  Tile action = Tile();
  List<Listenable> listened = [];

  void listenTo(Listenable listenable) {
    if (listened.contains(listenable)) return;
    listened.add(listenable);
  }

  void construct();

  BuildContext get context {
    if (dirtyContext?.mounted ?? false) return dirtyContext!;
    return navigatorKey.currentContext!;
  }

  Widget get visual => VisualLayer(layer: this, key: Key('$hashCode'));

  void layerChange() {
    construct();
    notifyListeners();
  }

  void disposeListeners() {
    for (var listenable in listened) {
      listenable.removeListener(layerChange);
    }
  }

  void initListeners() {
    listenTo(Preferences());
    for (var listenable in listened) {
      listenable.addListener(layerChange);
    }
  }

  bool get scroll => list.length > 6;

  void show() => showModalBottomSheet(
    barrierLabel: 'Barrier',
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (c) => visual,
  );
}
