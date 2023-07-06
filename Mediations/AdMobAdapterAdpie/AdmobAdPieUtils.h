
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AdPieSDK/AdPieSDK.h>

@interface AdmobAdPieUtils : NSObject
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (GADVersionNumber)adSDKVersion;
+ (GADVersionNumber)adapterVersion;
+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler;
+ (void)adPieSdkInitialize:(NSString*)mid completionHandler:(void(^)(BOOL result))completionHandler;
@end
