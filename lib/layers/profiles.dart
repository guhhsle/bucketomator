import 'package:flutter/material.dart';
import '../template/class/layer.dart';
import '../template/class/tile.dart';
import '../template/functions.dart';
import '../services/profile.dart';

class ProfilesLayer extends Layer {
  @override
  void construct() {
    listenTo(Profile.all);
    action = Tile('Profiles', Icons.person_rounded);
    list = Profile.all.value.map((p) => p.toTile);
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
    listenTo(Profile.all);
    action = Tile(profile.name, Icons.edit_rounded, '', () async {
      profile.name = await getInput(profile.name, 'Name');
      profile.backupCache();
    });

    final endPoint = protectText(profile.endPoint);
    final accessKey = protectText(profile.accessKey);
    final secretKey = protectText(profile.secretKey);

    list = [
      Tile('EndPoint', Icons.domain_rounded, endPoint, () async {
        String endPoint = await getInput(profile.endPoint, 'EndPoint');
        endPoint = endPoint.replaceAll('https://', '');
        endPoint = endPoint.replaceFirst('http://', '');
        profile.endPoint = endPoint;
        profile.backupCache();
      }),
      Tile('Access Key', Icons.key_rounded, accessKey, () async {
        final result = await getInput(profile.accessKey, 'Access Key');
        await profile.subStorage.cache.delete();
        profile.accessKey = result;
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
