#import "AdmobAdPieUtils.h"
#import "AdMobAdPieAdError.h"

@implementation AdmobAdPieUtils

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err == nil && [result isKindOfClass:[NSDictionary class]]) {
        return result;
    }
    return nil;
}

+ (GADVersionNumber)adSDKVersion {
    NSString *versionString = [AdPieSDK sdkVersion];
    NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
    
    GADVersionNumber version = {0};
    if (versionComponents.count >= 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (GADVersionNumber)adapterVersion {
    NSString *versionString = [NSString stringWithFormat:@"%@.0", [AdPieSDK sdkVersion]];
    NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count >= 4) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue] * 100 + [versionComponents[3] integerValue];
    }
    return version;
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler
{
    if ([[AdPieSDK sharedInstance] isInitialized]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil);
        });
        return;
    }
    
    NSString *parameter = configuration.credentials.firstObject.settings[@"parameter"];
    NSDictionary *info = [AdmobAdPieUtils dictionaryWithJsonString:parameter];
    NSString *appId = [info objectForKey:@"app_id"];
    
    if (appId == nil || appId.length == 0) {
        NSError *error = [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorSdkNotInitialize description:@"The app id is empty."];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(error);
        });
        return;
    }
    
    [[AdPieSDK sharedInstance] initWithMediaId:appId completion:^(BOOL isInitialized) {
        NSError *error = nil;
        if (!isInitialized) {
            error = [AdMobAdPieAdError errorWithCode:AdMobAdPieAdErrorSdkNotInitialize description:@"AdPie SDK must be initialized before ads loading."];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(error);
        });
    }];
}

+ (void)adPieSdkInitialize:(NSString*)mid completionHandler:(void(^)(BOOL result))completionHandler {
    
    if([[AdPieSDK sharedInstance] isInitialized]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(YES);
        });
        return;
    }
    
    if([mid length] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(NO);
        });
        return;
    }
    
    [[AdPieSDK sharedInstance] initWithMediaId:mid completion:^(BOOL isInitialized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(isInitialized);
        });
    }];
}

@end
