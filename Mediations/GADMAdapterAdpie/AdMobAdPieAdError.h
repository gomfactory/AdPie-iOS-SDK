#ifndef AdMobAdPieAdError_h
#define AdMobAdPieAdError_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const AdMobAdPieAdErrorDomain;

typedef NS_ENUM(NSInteger, AdMobAdPieAdErrorCode) {
    AdMobAdPieAdErrorUnknown          = -1,     // 알 수 없는 오류
    AdMobAdPieAdErrorTimeout          = -1001,  // Timeout
    AdMobAdPieAdErrorNoFill           = 100,    // 광고 없음
    AdMobAdPieAdErrorInvalidRequest   = 101,    // 잘못된 광고 요청
    AdMobAdPieAdErrorNetwork          = 102,    // 네트워크 오류
    AdMobAdPieAdErrorNoConnection     = 103,    // 인터넷 연결 오류
    AdMobAdPieAdErrorInternal         = 104,    // SDK 내부 오류
    AdMobAdPieAdErrorSdkNotInitialize = 105,    // SDK 초기화 미완료
    AdMobAdPieAdErrorDuplicateRequest = 106,    // 중복 요청
    AdMobAdPieAdErrorContentLoad      = 107,    // 컨텐츠 로딩 실패
    AdMobAdPieAdErrorServerData       = 108,    // 서버 데이터 오류
    AdMobAdPieAdErrorInvalidLayout    = 109,    // 레이아웃 설정 오류
    AdMobAdPieAdErrorLimitRequest     = 110,    // 광고 요청의 시간 제한
    AdMobAdPieAdErrorNoMediationData  = 111     // 미디에이션 정보 없음
};

@interface AdMobAdPieAdError: NSError

+ (NSError*)errorWithCode:(AdMobAdPieAdErrorCode)code;
+ (NSError*)errorWithCode:(NSInteger)code description:(NSString *)description;
+ (NSError*)errorWithDomain:(NSString *)domain code:(AdMobAdPieAdErrorCode)code;
+ (NSError*)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;

@end

NS_ASSUME_NONNULL_END


#endif /* AdMobAdPieAdError_h */
