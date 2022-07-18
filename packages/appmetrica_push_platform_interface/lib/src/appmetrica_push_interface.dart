import 'dart:async';

import 'models/permission_options.dart';

/// {@template AppmetricaPushInterface}
/// The interface that implementations of AppmetricaPush must implement.
/// {@endtemplate}
abstract class AppmetricaPushInterface {
  /// {@macro AppmetricaPushInterface}
  const AppmetricaPushInterface();

  /// Initializes the library in the app. Method should be invoked after initialization of the AppMetrica SDK.
  Future<void> activate();

  /// Token update stream.
  Stream<Map<String, String?>> get tokenStream;

  /// Returns a list of tokens for push providers that AppMetrica Push SDK was initialized with.
  Future<Map<String, String?>?> getTokens();

  /// Requests permissions to options
  Future<bool?> requestPermission(final PermissionOptions options);

  /// Returns the stream that is called when a silent push message
  /// is received from an incoming payload when the Flutter instance is in the foreground.
  Stream<String> get onMessage;

  /// Returns a Stream that is called when a user presses a notification message
  Stream<String> get onMessageOpenedApp;
}
