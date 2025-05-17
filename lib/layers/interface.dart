import '../../template/layer.dart';
import '../../template/tile.dart';
import '../../data.dart';

class InterfaceLayer extends Layer {
  @override
  void construct() {
    action = Tile.fromPref(Pref.appbar);
    list = [Tile.fromPref(Pref.autoCapitalise), Tile.fromPref(Pref.sheetBlobs)];
  }
}
