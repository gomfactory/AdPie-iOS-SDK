//
//  AdPieMediationAdapter.m
//  AdPieSample
//
//  Created by amondnet on 2023/03/29.
//
#import "AdPieMediationAdapter.h"
#import <Foundation/Foundation.h>
#import <AdPieSDK/AdPieSDK.h>


#define SDK_VERSION @"1.4.5"
#define ADAPTER_VERSION @"1.4.5.0"

@interface AdPieMediationAdapterAdViewDelegate : NSObject <APAdViewDelegate>
@property (nonatomic,   weak) AdPieMediationAdapter *parentAdapter;
@property (nonatomic, strong) id<MAAdViewAdapterDelegate> delegate;
@property (nonatomic, strong) MAAdFormat *adFormat;
- (instancetype)initWithParentAdapter:(AdPieMediationAdapter *)parentAdapter adFormat:(MAAdFormat *)adFormat andNotify:(id<MAAdViewAdapterDelegate>)delegate;
@end

@interface AdPieMediationAdapter ()

// AdView
@property (nonatomic, strong) AdPieMediationAdapterAdViewDelegate *adViewDelegate;
@property (nonatomic, strong) APAdView *adView;

@end

@implementation AdPieMediationAdapter

static ALAtomicBoolean *AdPieInitialized;

+ (void)initialize
{
    [super initialize];
    
    AdPieInitialized = [[ALAtomicBoolean alloc] init];
}

#pragma mark - MAAdapter Methods

- (NSString *)SDKVersion
{
    return SDK_VERSION;
}

- (NSString *)adapterVersion
{
    return ADAPTER_VERSION;
}

- (void)initializeWithParameters:(id<MAAdapterInitializationParameters>)parameters completionHandler:(void (^)(MAAdapterInitializationStatus, NSString *_Nullable))completionHandler
{
    if ( [AdPieInitialized compareAndSet: NO update: YES] )
    {
        NSString *appId = [parameters.serverParameters al_stringForKey: @"app_id"];
        [self log: @"Initializing AdPie SDK with app id: %@...", appId];
        [[AdPieSDK sharedInstance] initWithMediaId:appId];
        
        completionHandler(MAAdapterInitializationStatusInitializedSuccess, nil);
    }
    else
    {
        if ( AdPieSDK.sharedInstance.isInitialized ) {
            [self log: @"AdPie SDK is already initialized"];
            completionHandler(MAAdapterInitializationStatusInitializedSuccess, nil);
        }
        else
        {
            [self log: @"AdPie SDK still initializing"];
            completionHandler(MAAdapterInitializationStatusInitializing, nil);
        }
    }
}

- (void)destroy
{
    self.adView = nil;
    self.adViewDelegate = nil;
}

#pragma mark - MAAdViewAdapter Methods

- (void)loadAdViewAdForParameters:(id<MAAdapterResponseParameters>)parameters adFormat:(MAAdFormat *)adFormat andNotify:(id<MAAdViewAdapterDelegate>)delegate
{
    NSString *slotId = parameters.thirdPartyAdPlacementIdentifier;
    
    [self log: @"Loading %@%@ ad for slot id: %@...", adFormat.label, slotId];
    
    dispatchOnMainQueue(^{
      {
          self.adViewDelegate = [[AdPieMediationAdapterAdViewDelegate alloc] initWithParentAdapter: self adFormat: adFormat andNotify: delegate];
          self.adView = [[APAdView alloc] init];
          self.adView.slotId = slotId;
          self.adView.delegate = self.adViewDelegate;

          self.adView.frame = CGRectMake(0, 0, adFormat.size.width, adFormat.size.height);

          [self.adView load];
       }
    });
}

#pragma mark - Helper Methods

+ (MAAdapterError *)toMaxError:(NSInteger)adPieErrorCode
{
    MAAdapterError *adapterError = MAAdapterError.unspecified;
    NSString *thirdPartySdkErrorMessage;
    // https://github.com/gomfactory/AdPie-iOS-SDK/wiki/%EC%97%90%EB%9F%AC%EC%BD%94%EB%93%9C
    switch ( adPieErrorCode )
    {
        case 100:
            adapterError = MAAdapterError.noFill;
            thirdPartySdkErrorMessage = @"Ad was not ready at display time. Please try again.";
            break;
        case 101:
            adapterError = MAAdapterError.invalidConfiguration;
            thirdPartySdkErrorMessage = @"잘못된 요청 파라미터 (Media ID, Slot ID 확인)";
            break;
        case 102:
            adapterError = MAAdapterError.timeout;
            thirdPartySdkErrorMessage = @"네트워크 오류 (서버통신 오류, 지속시 문의필요)";
            break;
        case 103:
            adapterError = MAAdapterError.noConnection;
            thirdPartySdkErrorMessage = @"Please try again in a stable network environment.";
            break;
        case 104:
            adapterError = MAAdapterError.serverError;
            thirdPartySdkErrorMessage = @"내부 오류 (발생시 문의필요)";
            break;
        case 105:
            adapterError = MAAdapterError.notInitialized;
            thirdPartySdkErrorMessage = @"SDK 초기화 미완료 (연동 실패)";
            break;
        case 106:
            adapterError = MAAdapterError.invalidLoadState;
            thirdPartySdkErrorMessage = @"중복 요청 (기존 요청이 끝나기전에 재요청)";
            break;
        case 107:
            adapterError = MAAdapterError.unspecified;
            thirdPartySdkErrorMessage = @"컨텐츠 로딩 오류 (웹뷰의 컨텐츠 로딩실패)";
            break;
        case 108:
            adapterError = MAAdapterError.internalError;
            thirdPartySdkErrorMessage = @"서버 데이터 오류 (데이터 파싱, 지속시 문의필요)";
            break;
        case 109:
            adapterError = MAAdapterError.adDisplayFailedError;
            thirdPartySdkErrorMessage = @"레이아웃 설정 오류 (배너의 경우 백그라운드 상태이거나 잘못된 슬롯 사이즈, 네이티브의 경우 필수 요소가 빠진 상태)";
            break;
        case 110:
            adapterError = MAAdapterError.timeout;
            thirdPartySdkErrorMessage = @"광고 요청의 시간 제한 (기존 요청의 시간 비교 후 서버 전송 없음)";
            break;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [MAAdapterError errorWithCode: adapterError.errorCode
                             errorString: adapterError.errorMessage
                  thirdPartySdkErrorCode: adPieErrorCode
               thirdPartySdkErrorMessage: thirdPartySdkErrorMessage];
#pragma clang diagnostic pop
}

@end


@implementation AdPieMediationAdapterAdViewDelegate

- (instancetype)initWithParentAdapter:(AdPieMediationAdapter *)parentAdapter adFormat:(MAAdFormat *)adFormat andNotify:(id<MAAdViewAdapterDelegate>)delegate
{
    self = [super init];
    if ( self )
    {
        self.parentAdapter = parentAdapter;
        self.delegate = delegate;
        self.adFormat = adFormat;
    }
    return self;
}

- (void)adViewDidLoadAd:(APAdView *)view {
    // 광고 표출 성공 후 이벤트 발생
    
    [self.parentAdapter log: @"%@ ad loaded for slot id: %@...", self.adFormat.label, view.slotId];

}

- (void)adViewDidFailToLoadAd:(APAdView *)view withError:(NSError *)error {
    // 광고 요청 또는 표출 실패 후 이벤트 발생
    // error code : [error code]
    // error message : [error localizedDescription]
    NSInteger errorCode = error.code;
    // error message : [error localizedDescription]
    [self.parentAdapter log: @"%@ ad failed to load for slot id: %@ with error: %ld", self.adFormat.label, view.slotId, errorCode];
    MAAdapterError *maxError = [AdPieMediationAdapter toMaxError: errorCode];
    [self.delegate didFailToLoadAdViewAdWithError: maxError];
}

- (void)adViewWillLeaveApplication:(APAdView *)view {
    // 광고 클릭 후 이벤트 발생
    [self.parentAdapter log: @"%@ ad clicked for slot id: %@...", self.adFormat.label, view.slotId];
    [self.delegate didClickAdViewAd];
}

@end
