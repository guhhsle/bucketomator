import 'package:flutter/material.dart';
import '../template/class/layer.dart';
import '../template/class/tile.dart';
import '../template/functions.dart';
import '../services/profile.dart';

class ProfilesLayer extends Layer {
  @override
  void construct() {
    listenTo(Profile.cache);
    action = Tile('Profiles', Icons.person_rounded);
    list = Profile.cache.value.map((p) => p.toTile);
    trailing = [
      IconButton(icon: Icon(Icons.add_rounded), onPressed: () => Profile.empty),
    ];
  }
}

class ProfileLayer extends Layer {
  final Profile profile;

  ProfileLayer({required this.profile});

  String protectText(String s) => s.isEmpty ? '' : '***';

  @override
  void construct() {
    listenTo(Profile.cache);
    action = Tile(profile.name, Icons.edit_rounded, '', () async {
      profile.name = await getInput(profile.name, 'Name');
      profile.backupCache();
    });

    final endPoint = protectText(profile.endPoint);
    final accessKey = protectText(profile.accessKey);
    final secretKey = protectText(profile.secretKey);

    list = [
      Tile('EndPoint', Icons.domain_rounded, endPoint, () async {
        profile.endPoint = await getInput(profile.endPoint, 'EndPoint');
        profile.backupCache();
      }),
      Tile('Access Key', Icons.key_rounded, accessKey, () async {
        profile.accessKey = await getInput(profile.accessKey, 'Access Key');
        profile.backupCache();
      }),
      Tile('Secret Key', Icons.password_rounded, secretKey, () async {
        profile.secretKey = await getInput(profile.secretKey, 'Secret Key');
        profile.backupCache();
      }),
    ];
    trailing = [
      IconButton(
        icon: Icon(Icons.delete_forever_rounded),
        onPressed: () => profile.delete(),
      ),
    ];
  }
}
