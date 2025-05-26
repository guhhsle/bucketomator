import '../template/class/layer.dart';
import '../template/class/tile.dart';
import '../../data.dart';

class InterfaceLayer extends Layer {
  @override
  void construct() {
    action = Tile.fromPref(Pref.appbar);
    list = [
      Tile.fromPref(
        Pref.gridCount,
        onPrefInput: (s) => Pref.gridCount.set(int.parse(s).clamp(1, 100)),
      ),
      Tile.fromPref(Pref.autoCapitalise),
      Tile.fromPref(Pref.refresh),
      Tile.fromPref(Pref.sheetBlobs),
    ];
  }
}
