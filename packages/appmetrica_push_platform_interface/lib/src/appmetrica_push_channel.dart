import 'dart:async';

import 'package:flutter/services.dart';

import 'appmetrica_push_platform_interface.dart';
import 'constants.dart';
import 'models/permission_options.dart';

/// {@template AppmetricaPushChannel}
/// An implementation of [AppmetricaPushPlatformInterface] that uses method channels.
/// {@endtemplate}
class AppmetricaPushChannel extends AppmetricaPushPlatformInterface {
  /// {@macro AppmetricaPushChannel}
  AppmetricaPushChannel() {
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case kOnMessage:
          final String? msg = call.arguments as String?;

          if (msg != null && msg.isNotEmpty == true) {
            AppmetricaPushPlatformInterface.instance.onMessageController
                .add(msg);
          }
          break;
        case kOnMessageOpenedApp:
          final String? msg = call.arguments as String?;

          if (msg != null && msg.isNotEmpty == true) {
            AppmetricaPushPlatformInterface
                .instance.onMessageOpenedAppController
                .add(msg);
          }
          break;
      }
    });
  }

  static const MethodChannel _methodChannel = MethodChannel(kMethodChannel);
  static const EventChannel _eventChannel = EventChannel(kEventChannel);

  @override
  Future<void> activate() async => _methodChannel.invokeMethod<void>(kActivate);

  @override
  Future<Map<String, String?>?> getTokens() async =>
      _methodChannel.invokeMapMethod<String, String?>(kGetTokens);

  @override
  Future<bool?> requestPermission(final PermissionOptions options) async =>
      _methodChannel.invokeMethod<bool>(
        kRequestPermission,
        options.toJson(),
      );

  @override
  Stream<Map<String, String?>> get tokenStream =>
      _eventChannel.receiveBroadcastStream().map(
            (dynamic v) =>
                Map<String, String?>.from(v as Map<Object?, Object?>),
          );

  @override
  Stream<String> get onMessage =>
      AppmetricaPushPlatformInterface.instance.onMessageController.stream;

  @override
  Stream<String> get onMessageOpenedApp => AppmetricaPushPlatformInterface
      .instance.onMessageOpenedAppController.stream;
}
