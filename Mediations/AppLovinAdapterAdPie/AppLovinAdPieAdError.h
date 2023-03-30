#ifndef AppLovinAdPieAdError_h
#define AppLovinAdPieAdError_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const AppLovinAdPieAdErrorDomain;

typedef NS_ENUM(NSInteger, AppLovinAdPieAdErrorCode) {
    AppLovinAdPieAdErrorUnknown          = -1,     // 알 수 없는 오류
    AppLovinAdPieAdErrorTimeout          = -1001,  // Timeout
    AppLovinAdPieAdErrorNoFill           = 100,    // 광고 없음
    AppLovinAdPieAdErrorInvalidRequest   = 101,    // 잘못된 광고 요청
    AppLovinAdPieAdErrorNetwork          = 102,    // 네트워크 오류
    AppLovinAdPieAdErrorNoConnection     = 103,    // 인터넷 연결 오류
    AppLovinAdPieAdErrorInternal         = 104,    // SDK 내부 오류
    AppLovinAdPieAdErrorSdkNotInitialize = 105,    // SDK 초기화 미완료
    AppLovinAdPieAdErrorDuplicateRequest = 106,    // 중복 요청
    AppLovinAdPieAdErrorContentLoad      = 107,    // 컨텐츠 로딩 실패
    AppLovinAdPieAdErrorServerData       = 108,    // 서버 데이터 오류
    AppLovinAdPieAdErrorInvalidLayout    = 109,    // 레이아웃 설정 오류
    AppLovinAdPieAdErrorLimitRequest     = 110,    // 광고 요청의 시간 제한
    AppLovinAdPieAdErrorNoMediationData  = 111     // 미디에이션 정보 없음
};

@interface AppLovinAdPieAdError: NSError

+ (NSError*)errorWithCode:(AppLovinAdPieAdErrorCode)code;
+ (NSError*)errorWithCode:(NSInteger)code description:(NSString *)description;
+ (NSError*)errorWithDomain:(NSString *)domain code:(AppLovinAdPieAdErrorCode)code;
+ (NSError*)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;

@end

NS_ASSUME_NONNULL_END


#endif /* AppLovinAdPieAdError_h */

