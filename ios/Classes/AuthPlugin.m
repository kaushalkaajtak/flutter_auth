#import "AuthPlugin.h"
#if __has_include(<auth/auth-Swift.h>)
#import <auth/auth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "auth-Swift.h"
#endif

@implementation AuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAuthPlugin registerWithRegistrar:registrar];
}
@end
