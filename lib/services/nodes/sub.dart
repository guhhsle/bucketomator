import 'dart:io';
import 'loadable.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';
import '../../layers/nodes/cache.dart';
import '../transfer.dart';
import '../../functions.dart';
import '../../data.dart';

abstract class SubNode extends LoadableNode {
  String path; //Path inside the bucket
  FileSystemEntity? fsEntity;
  DateTime? date;
  int? size;

  SubNode({
    required this.path,
    super.parent,
    this.date,
    this.size,
    this.fsEntity,
  });

  String get name => nameFromPath(path);
  String get displayName {
    if (Pref.autoCapitalise.value) return capitalize(name);
    return name;
  }

  void open();
  String get fullPath => '${bucket.name}/$path';

  Transfer get forceRemove;

  void tryRemove() => showSnack(
    'Press to confirm for $name',
    false,
    onTap: () => forceRemove.call(),
  );

  Tile get toTile;

  Tile get toCacheTile {
    final tile = toTile;
    tile.title = name.padLeft(name.length + depth, '.');
    tile.onHold = CachedNodeLayer(node: this).show;
    return tile;
  }
}
