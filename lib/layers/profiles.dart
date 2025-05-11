import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../services/profile.dart';
import '../template/layer.dart';
import '../template/tile.dart';

class ProfilesLayer extends Layer {
  @override
  void construct() {
    action = Tile('Profiles', Icons.person_rounded);
    list = Profiles().allProfiles.map((p) => p.toTile);
    trailing = [
      IconButton(
        icon: Icon(Icons.add_rounded),
        onPressed: () => Profile.empty.add(),
      ),
    ];
  }
}

class ProfileLayer extends Layer {
  final Profile profile;

  ProfileLayer({required this.profile});

  @override
  void construct() {
    action = Tile(profile.name, Icons.edit_rounded, '', () async {
      profile.name = await getInput(profile.name, 'Name');
      profile.backup();
    });
    list = [
      Tile('EndPoint', Icons.domain_rounded, '***', () async {
        profile.endPoint = await getInput(profile.endPoint, 'EndPoint');
        profile.backup();
      }),
      Tile('Access Key', Icons.key_rounded, '***', () async {
        profile.accessKey = await getInput(profile.accessKey, 'Access Key');
        profile.backup();
      }),
      Tile('Secret Key', Icons.password_rounded, '***', () async {
        profile.secretKey = await getInput(profile.secretKey, 'Secret Key');
        profile.backup();
      }),
    ];
    trailing = [
      IconButton(
        icon: Icon(Icons.delete_forever_rounded),
        onPressed: profile.remove,
      ),
    ];
  }
}
