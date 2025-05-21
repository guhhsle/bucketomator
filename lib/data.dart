import 'package:flutter/material.dart';
import 'template/class/prefs.dart';
import 'template/class/tile.dart';
import 'layers/interface.dart';
import 'template/theme.dart';

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
  //QUICK MENU
  nodeSort('Sorting', 'Name Asc', Icons.sort_rounded, ui: true, all: nodeSorts),
  prefixFirst('Folders First', true, Icons.folder_rounded, ui: true),
  showHidden('Show hidden', true, Icons.visibility, ui: true),
  //PROFILES
  profiles('Profiles', <String>[], null),
  currentProfile('Current Profile', '', null),
  //INTERFACE
  autoCapitalise('Auto Capitalise', false, Icons.text_fields_rounded, ui: true),
  sheetBlobs('Sheet blobs', false, Icons.border_bottom_rounded),
  //CACHE
  cachePath(null, '', null),
  autoRefresh('Auto refresh', true, Icons.refresh_rounded, ui: true);

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
    Tile('Primary', Icons.colorize_rounded, '', ThemeLayer(true).show),
    Tile('Background', Icons.tonality_rounded, '', ThemeLayer(false).show),
  ];
}

enum Status { pending, inProgress, completed, failed }

enum BlobType {
  image,
  pdf,
  video,
  text;

  static BlobType fromExtension(String ext) {
    for (final entry in extensions.entries) {
      if (entry.value.contains(ext)) return entry.key;
    }
    return BlobType.defaultType;
  }

  static BlobType get defaultType => BlobType.text;

  bool get isFixedHeight {
    if (this == BlobType.pdf) return false;
    return true;
  }
}

const extensions = {
  BlobType.image: ['jpg', 'png', 'gif', 'webp'],
  BlobType.video: ['mp4'],
  BlobType.pdf: ['pdf'],
};
