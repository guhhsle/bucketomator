import '../data.dart';
import '../template/layer.dart';
import '../template/tile.dart';

class ConnectionLayer extends Layer {
  @override
  void construct() {
    action = Tile.fromPref(
      Pref.endPoint,
      onPrefInput: (s) => Pref.endPoint.set(s),
    );
    list = [
      Tile.fromPref(Pref.accessKey, onPrefInput: (s) => Pref.accessKey.set(s)),
      Tile.fromPref(Pref.secretKey, onPrefInput: (s) => Pref.secretKey.set(s)),
    ];
  }
}
