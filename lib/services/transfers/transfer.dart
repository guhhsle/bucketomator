import 'package:flutter/material.dart';
import 'manager.dart';
import '../../template/class/tile.dart';
import '../../data.dart';

class Transfer<T> extends ChangeNotifier {
  String? errorMessage;
  Future<T>? future;
  Transfer? parent;
  String title;
  Status futureStatus;

  Status get status => futureStatus;

  Transfer(
    this.title, {
    this.future,
    this.parent,
    this.errorMessage,
    this.futureStatus = Status.pending,
  });

  Future<T> call() => TransferManager().addAndStart(this) as Future<T>;

  Future<T?> forceStart() async {
    T? result;
    try {
      futureStatus = Status.inProgress;
      notify();
      result = await future;
    } catch (e) {
      futureStatus = Status.failed;
      errorMessage = '$e';
      throw Error();
    }
    futureStatus = Status.completed;
    notify();
    return result;
  }

  void notify() {
    Transfer? transfer = this;
    while (transfer != null) {
      transfer.notifyListeners();
      transfer = transfer.parent;
    }
  }

  Transfer copyWith({
    String? errorMessage,
    Transfer? parent,
    Future<T>? future,
    String? title,
  }) => Transfer(
    title ?? this.title,
    parent: parent ?? this.parent,
    future: future ?? this.future,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  Tile get toTile => Tile(title, icon);

  IconData get icon =>
      {
        Status.pending: Icons.schedule_rounded,
        Status.failed: Icons.error_rounded,
        Status.inProgress: Icons.timelapse_rounded,
        Status.completed: Icons.done_rounded,
      }[status] ??
      Icons.moped_rounded;
}
