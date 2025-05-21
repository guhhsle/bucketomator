import '../template/class/layer.dart';
import '../template/class/tile.dart';
import '../../data.dart';

class InterfaceLayer extends Layer {
  @override
  void construct() {
    action = Tile.fromPref(Pref.appbar);
    list = [
      Tile.fromPref(Pref.autoCapitalise),
      Tile.fromPref(Pref.autoRefresh),
      Tile.fromPref(Pref.sheetBlobs),
    ];
  }
}
