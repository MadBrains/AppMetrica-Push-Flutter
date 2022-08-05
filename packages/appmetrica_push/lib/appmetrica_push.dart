library appmetrica_push;

import 'dart:async';

import 'package:appmetrica_push_platform_interface/appmetrica_push_platform_interface.dart';

export 'package:appmetrica_push_platform_interface/appmetrica_push_platform_interface.dart'
    show AppmetricaPushInterface, PermissionOptions;

/// {@template AppmetricaPush}
/// Methods of the class are used for configuring the AppMetrica Push SDK library.
/// {@endtemplate}
class AppmetricaPush implements AppmetricaPushInterface {
  const AppmetricaPush._();

  static const AppmetricaPushInterface _instance = AppmetricaPush._();

  /// instance
  static AppmetricaPushInterface get instance => _instance;

  @override
  Future<void> activate() async =>
      AppmetricaPushPlatformInterface.instance.activate();

  @override
  Future<Map<String, String?>?> getTokens() async =>
      AppmetricaPushPlatformInterface.instance.getTokens();

  @override
  Future<bool?> requestPermission(final PermissionOptions options) async =>
      AppmetricaPushPlatformInterface.instance.requestPermission(options);

  @override
  Stream<Map<String, String?>> get tokenStream =>
      AppmetricaPushPlatformInterface.instance.tokenStream;

  @override
  Stream<String> get onMessage =>
      AppmetricaPushPlatformInterface.instance.onMessage;

  @override
  Stream<String> get onMessageOpenedApp =>
      AppmetricaPushPlatformInterface.instance.onMessageOpenedApp;
}
