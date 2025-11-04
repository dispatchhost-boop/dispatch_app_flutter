import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final internetProvider = ChangeNotifierProvider((ref) => InternetProvider());

// Your existing InternetProvider logic using ChangeNotifier
class InternetProvider extends ChangeNotifier {
  bool _hasConnection = true;
  bool get hasConnection => _hasConnection;

  final Connectivity _connectivity = Connectivity();

  InternetProvider() {
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen((resultList) {
      _updateStatus(resultList);
    });
  }

  void _initConnectivity() async {
    final resultList = await _connectivity.checkConnectivity();
    _updateStatus(resultList);
  }

  void _updateStatus(List<ConnectivityResult> resultList) {
    final result = resultList.isNotEmpty ? resultList.first : ConnectivityResult.none;
    final isConnected = result != ConnectivityResult.none;
    if (_hasConnection != isConnected) {
      _hasConnection = isConnected;
      notifyListeners();
    }
  }

  Future<bool> checkConnection() async {
    final resultList = await Connectivity().checkConnectivity();
    final result = resultList.isNotEmpty ? resultList.first : ConnectivityResult.none;
    return result != ConnectivityResult.none;
  }
}
