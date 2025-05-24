import 'package:flutter/material.dart';
import 'package:minio/minio.dart';
import 'dart:convert';
import 'storage/substorage.dart';
import '../template/class/tile.dart';
import '../layers/profiles.dart';
import '../data.dart';

class Profile with ChangeNotifier {
  String name, endPoint;
  String accessKey, secretKey;
  late SubStorage subStorage;

  static ValueNotifier<Set<Profile>> all = ValueNotifier({});

  factory Profile({
    required String name,
    required String endPoint,
    required String accessKey,
    required String secretKey,
  }) {
    final temp = Profile.internal(
      name: name,
      endPoint: endPoint,
      accessKey: accessKey,
      secretKey: secretKey,
    );
    final original = all.value.lookup(temp);
    if (original != null) return original;
    all.value = {...all.value, temp};
    return temp;
  }

  Profile.internal({
    required this.name,
    required this.endPoint,
    required this.accessKey,
    required this.secretKey,
  }) {
    subStorage = SubStorage(profile: this);
  }

  static Profile fromString(String s) => fromMap(jsonDecode(s));

  static Profile fromMap(Map map) => Profile(
    name: map['name'] ?? '?',
    endPoint: map['endPoint'] ?? '',
    accessKey: map['accessKey'] ?? '',
    secretKey: map['secretKey'] ?? '',
  );

  Map get toMap => {
    'name': name,
    'endPoint': endPoint,
    'accessKey': accessKey,
    'secretKey': secretKey,
  };

  static Profile get empty =>
      Profile(name: 'Edit profile', endPoint: '', accessKey: '', secretKey: '');

  @override
  String toString() => jsonEncode(toMap);

  Tile get toTile => Tile.complex(
    name,
    Icons.person_rounded,
    isSelected ? '*' : '',
    select,
    onHold: ProfileLayer(profile: this).show,
  );
  Minio get toMinio {
    return Minio(
      endPoint: endPoint,
      accessKey: accessKey,
      secretKey: secretKey,
    );
  }

  bool get isSelected => Pref.accessKey.value == accessKey;
  void select() {
    Pref.accessKey.set(accessKey);
    subStorage.root.casuallyRefresh();
  }

  @override
  bool operator ==(Object other) =>
      other is Profile && other.accessKey == accessKey;

  @override
  int get hashCode => accessKey.hashCode;

  static void initCache() {
    for (final str in Pref.profiles.value) {
      Profile.fromString(str);
    }
  }

  void backupCache() {
    List<String> strings = [];
    for (final profile in all.value) {
      strings.add('$profile');
    }
    Pref.profiles.set(strings);
  }

  static Profile get current {
    for (final profile in all.value) {
      if (profile.isSelected) return profile;
    }
    return Profile.empty;
  }

  Future<void> delete() async {
    await subStorage.cache.delete();
    all.value = {...all.value..remove(this)};
    backupCache();
  }
}
