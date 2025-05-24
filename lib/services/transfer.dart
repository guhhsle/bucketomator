import 'package:flutter/material.dart';
import '../../template/class/tile.dart';
import '../../template/functions.dart';
import '../layers/transfer.dart';
import '../../data.dart';

class Transfer<T> extends ChangeNotifier {
  static ValueNotifier<Set<Transfer>> all = ValueNotifier({});
  String? errorMessage;
  Status _futureStatus = Status.pending;
  Future<T>? future;
  Transfer? parent;
  String title;

  Transfer(this.title, {this.future, this.parent}) {
    all.value = {...all.value, this};
    addListener(() => all.value = {...all.value});
  }

  Status get status => _futureStatus;
  set status(Status status) {
    _futureStatus = status;
    notifyListeners();
  }

  Future<T?> call() async {
    if (parent == null) TransferLayer().show();
    T? result;
    try {
      status = Status.inProgress;
      result = await future;
    } catch (e) {
      status = Status.failed;
      errorMessage = '$e';
      showSnack('$e', false);
      rethrow;
    }
    status = Status.completed;
    return result;
  }

  Transfer copyWith({Transfer? parent, Future<T>? future, String? title}) {
    this.parent = parent ?? this.parent;
    this.future = future ?? this.future;
    this.title = title ?? this.title;
    return this;
  }

  Tile get toTile => Tile(title, icon, '', () {
    TransferLayer(root: this).show();
  });

  IconData get icon =>
      {
        Status.pending: Icons.schedule_rounded,
        Status.failed: Icons.error_rounded,
        Status.inProgress: Icons.timelapse_rounded,
        Status.completed: Icons.done_rounded,
      }[status] ??
      Icons.moped_rounded;
}
