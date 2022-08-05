import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'appmetrica_push_channel.dart';
import 'appmetrica_push_interface.dart';

/// The interface that implementations of AppmetricaPush must implement.
abstract class AppmetricaPushPlatformInterface extends PlatformInterface
    implements AppmetricaPushInterface {
  /// Constructs a AppmetricaPushPlatformInterface.
  AppmetricaPushPlatformInterface() : super(token: _token);

  static AppmetricaPushPlatformInterface _instance = AppmetricaPushChannel();

  static const Object _token = Object();

  /// The default instance of [AppmetricaPushPlatformInterface] to use.
  ///
  /// Defaults to [AppmetricaPushChannel].
  static AppmetricaPushPlatformInterface get instance => _instance;

  /// Platform-specific plugins should set this with their own
  /// platform-specific class that extends [AppmetricaPushPlatformInterface] when they
  /// register themselves.
  static set instance(AppmetricaPushPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Message Stream Controller
  final StreamController<String> onMessageController =
      StreamController<String>.broadcast();

  /// Message Opened App Stream Controller
  final StreamController<String> onMessageOpenedAppController =
      StreamController<String>.broadcast();
}
