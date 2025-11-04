#import "KycWorkflowPlugin.h"
#if __has_include(<kyc_workflow/kyc_workflow-Swift.h>)
#import <kyc_workflow/kyc_workflow-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "kyc_workflow-Swift.h"
#endif

@implementation KycWorkflowPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKycWorkflowPlugin registerWithRegistrar:registrar];
}
@end
