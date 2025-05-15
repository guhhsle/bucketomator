import 'package:flutter/material.dart';
import 'transfer.dart';

class TransferManager with ChangeNotifier {
  static final instance = TransferManager.internal();
  factory TransferManager() => instance;
  TransferManager.internal();

  List<Transfer> transfers = [];

  Future addAndStart(Transfer transfer) async {
    transfers.add(transfer);
    transfer.addListener(() => notifyListeners());
    return await transfer.forceStart();
  }
}
