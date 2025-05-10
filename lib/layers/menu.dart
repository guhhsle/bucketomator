import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../template/settings.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';
import 'profiles.dart';

class MenuLayer extends Layer {
  @override
  void construct() {
    action = Tile('Settings', Icons.tune_rounded, '', () {
      goToPage(const PageSettings());
    });
    list = [
      Tile('Profiles', Icons.person_rounded, '', ProfilesLayer().show),
      Tile.fromPref(Pref.nodeSort),
      Tile.fromPref(Pref.showHidden),
      Tile.fromPref(Pref.prefixFirst),
    ];
  }
}
