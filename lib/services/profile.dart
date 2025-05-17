import 'package:flutter/material.dart';
import 'package:minio/minio.dart';
import 'dart:convert';
import 'nodes/root.dart';
import '../template/class/tile.dart';
import '../layers/profiles.dart';
import '../data.dart';

class Profile {
  String name, endPoint;
  String accessKey, secretKey;

  Profile({
    required this.name,
    required this.endPoint,
    required this.accessKey,
    required this.secretKey,
  });

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
      Profile(name: 'New', endPoint: '', accessKey: '', secretKey: '');

  @override
  String toString() => jsonEncode(toMap);

  Tile get toTile => Tile.complex(
    name,
    Icons.person_rounded,
    selected ? '*' : '',
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

  void backup() => Profiles().backup();
  void remove() => Profiles().remove(this);
  void add() => Profiles().add(this);
  bool get selected => Pref.currentProfile.value == name;
  void select() {
    Pref.currentProfile.set(name);
    RootNode().refresh();
  }
}

class Profiles {
  static final instance = Profiles.internal();
  factory Profiles() => instance;
  Profiles.internal();

  List<Profile> allProfiles = [];

  void init() {
    for (final str in Pref.profiles.value) {
      allProfiles.add(Profile.fromString(str));
    }
  }

  void backup() {
    List<String> strings = [];
    for (final profile in allProfiles) {
      strings.add('$profile');
    }
    Pref.profiles.set(strings);
  }

  Profile get current {
    for (final profile in allProfiles) {
      if (profile.name == Pref.currentProfile.value) {
        return profile;
      }
    }
    return Profile.empty;
  }

  void remove(Profile profile) {
    allProfiles.remove(profile);
    backup();
  }

  void add(Profile profile) {
    allProfiles.add(profile);
    backup();
  }
}
