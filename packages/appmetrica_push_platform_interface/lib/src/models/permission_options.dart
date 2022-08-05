import 'dart:convert';

/// {@template PermissionOptions}
///
/// {@endtemplate}
class PermissionOptions {
  /// {@macro PermissionOptions}
  const PermissionOptions({
    this.alert = false,
    this.badge = false,
    this.sound = false,
  });

  /// Show alert
  final bool alert;

  /// Show badge
  final bool badge;

  /// Play sound
  final bool sound;
}

/// extension for PermissionOptions
extension PermissionOptionsX on PermissionOptions {
  /// Map to Json
  String toJson() {
    return json.encode(
      <String, dynamic>{
        'alert': alert,
        'badge': badge,
        'sound': sound,
      },
    );
  }
}
