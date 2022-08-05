import 'dart:async';

import 'package:appmetrica_push_platform_interface/appmetrica_push_platform_interface_private.dart';

export 'package:appmetrica_push_platform_interface/appmetrica_push_platform_interface.dart'
    show AppmetricaPushInterface, PermissionOptions;

/// An implementation of [AppmetricaPushPlatformInterface] that uses method channels.
class AppmetricaPushIos extends AppmetricaPushPlatformInterface {
  AppmetricaPushIos._();
  static final AppmetricaPushPlatformInterface _instance =
      AppmetricaPushIos._();

  /// The default instance of [AppmetricaPushPlatformInterface] to use.
  ///
  /// Defaults to [AppmetricaPushIos].
  static AppmetricaPushInterface get instance => _instance;

  /// Registers this class as the default instance of [AppmetricaPushPlatformInterface].
  static void registerWith() {
    AppmetricaPushPlatformInterface.instance = _instance;
  }

  late final AppmetricaPushChannel _channel = AppmetricaPushChannel();

  @override
  Future<void> activate() async => _channel.activate();

  @override
  Future<Map<String, String?>?> getTokens() async => _channel.getTokens();

  @override
  Future<bool?> requestPermission(final PermissionOptions options) async =>
      _channel.requestPermission(options);

  @override
  Stream<Map<String, String?>> get tokenStream => _channel.tokenStream;

  @override
  Stream<String> get onMessage => _channel.onMessage;

  @override
  Stream<String> get onMessageOpenedApp => _channel.onMessageOpenedApp;
}
