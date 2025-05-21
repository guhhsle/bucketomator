import 'package:flutter/material.dart';
import '../../data.dart';

abstract class LoadableNode with ChangeNotifier {
  Status _cacheStatus = Status.pending;
  Status _serverStatus = Status.pending;

  Status get cacheStatus => _cacheStatus;
  Status get serverStatus => _serverStatus;

  set cacheStatus(Status s) {
    _cacheStatus = s;
    notifyListeners();
  }

  set serverStatus(Status s) {
    _serverStatus = s;
    notifyListeners();
  }

  Future<void> refresh(bool force);
}
