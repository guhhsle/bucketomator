import 'package:flutter/material.dart';
import 'layers/connection.dart';
import 'layers/interface.dart';
import 'template/prefs.dart';
import 'template/theme.dart';
import 'template/tile.dart';

const locales = [
  ...['Serbian', 'English', 'Spanish', 'German', 'French', 'Italian'],
  ...['Polish', 'Portuguese', 'Russian', 'Slovenian', 'Japanese'],
];
const tops = ['Primary', 'Black', 'Transparent'];
const nodeSorts = [
  ...['Name Asc', 'Name Desc', 'Date Asc'],
  ...['Date Desc', 'Size Asc', 'Size Desc'],
];

enum Pref<T> {
  //TEMPLATE
  font('Font', 'JetBrainsMono', Icons.format_italic_rounded, ui: true),
  locale('Language', 'English', Icons.language_rounded, ui: true, all: locales),
  appbar('Top', 'Black', Icons.gradient_rounded, all: tops, ui: true),
  background(null, 'F0F8FF', null, ui: true),
  primary(null, '000000', null, ui: true),
  backgroundDark(null, '000000', null, ui: true),
  primaryDark(null, 'F6F7EB', null, ui: true),
  debug('Developer', false, Icons.code_rounded),
  //CONNECTION
  endPoint('EndPoint', '', Icons.domain_rounded, secret: true),
  accessKey('Access Key', '', Icons.key_rounded, secret: true),
  secretKey('Secret Key', '', Icons.password_rounded, secret: true),
  //QUICK MENU
  nodeSort('Sorting', 'Name Asc', Icons.sort_rounded, ui: true, all: nodeSorts),
  prefixFirst('Folders First', true, Icons.folder_rounded, ui: true),
  showHidden('Show hidden', true, Icons.visibility, ui: true);

  final T initial;
  final List<T>? all;
  final String? title; //Backend is null
  final IconData? icon;
  final bool ui, secret;

  const Pref(
    this.title,
    this.initial,
    this.icon, {
    this.all,
    this.ui = false,
    this.secret = false,
  });

  T get value => Preferences.get(this);

  Future set(T val) => Preferences.set(this, val);

  Future rev() => Preferences.rev(this);

  Future next() => Preferences.next(this);

  void nextByLayer({String suffix = ''}) {
    NextByLayer(this, suffix: suffix).show();
  }

  @override
  toString() => name;
}

List<Tile> get settings {
  return [
    Tile('Interface', Icons.toggle_on, '', InterfaceLayer().show),
    Tile('Connection', Icons.domain_rounded, '', ConnectionLayer().show),
    Tile('Primary', Icons.colorize_rounded, '', ThemeLayer(true).show),
    Tile('Background', Icons.tonality_rounded, '', ThemeLayer(false).show),
  ];
}
