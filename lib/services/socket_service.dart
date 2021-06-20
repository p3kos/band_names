import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  final port = '3000';
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  ServerStatus get serverStatus => this._serverStatus;

  void _initConfig() {
    // Dart client
    this._socket = IO.io(
        (Platform.isIOS ? 'http://localhost:' : 'http://192.168.0.8:') + port, {
      'transports': ['websocket'],
      'autoConnect': true
    });
    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /* socket.on('nuevo-mensaje', (payload) {
      print('nuevo mensaje : $payload');
    }); */
  }
}
