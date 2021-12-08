#import "NativeDup2Plugin.h"
#if __has_include(<native_dup2/native_dup2-Swift.h>)
#import <native_dup2/native_dup2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_dup2-Swift.h"
#endif

@implementation NativeDup2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeDup2Plugin registerWithRegistrar:registrar];
}
@end
