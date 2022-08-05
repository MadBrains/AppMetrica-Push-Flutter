#import "AppmetricaPushIosPlugin.h"
#if __has_include(<appmetrica_push_ios/appmetrica_push_ios-Swift.h>)
#import <appmetrica_push_ios/appmetrica_push_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appmetrica_push_ios-Swift.h"
#endif

@implementation AppmetricaPushIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppmetricaPushIosPlugin registerWithRegistrar:registrar];
}
@end
