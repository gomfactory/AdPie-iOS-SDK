#import "AdMobAdPieAdError.h"

NSString *const AdMobAdPieAdErrorDomain = @"com.admob.adpie.sdk.error";

@implementation AdMobAdPieAdError

+ (NSString *)errorDescriptionWithCode:(AdMobAdPieAdErrorCode)code {
    NSString *description;
    
    switch (code) {
        case AdMobAdPieAdErrorTimeout: // Time out
            description = @"The request timed out.";
            break;
            
        case AdMobAdPieAdErrorNoFill: // 광고 없음
            description = @"No fill.";
            break;
            
        case AdMobAdPieAdErrorInvalidRequest: // 잘못된 광고 요청 (App ID, AdUnit ID 확인)
            description = @"Invalid ad request.";
            break;
            
        case AdMobAdPieAdErrorNetwork: // 네트워크 오류 (서버 통신 오류)
            description = @"A network error occurred.";
            break;
            
        case AdMobAdPieAdErrorNoConnection: // 인터넷 연결 오류 (인터넷 연결 상태 확인)
            description = @"No internet connection detected.";
            break;
            
        case AdMobAdPieAdErrorInternal: // 내부 오류
            description = @"An internal error occurred.";
            break;
            
        case AdMobAdPieAdErrorSdkNotInitialize: // SDK 초기화 미완료
            description = @"SDK must be initialized before ads loading.";
            break;
            
        case AdMobAdPieAdErrorDuplicateRequest: // 중복 요청 (기존 요청이 끝나기 전에 재요청)
            description = @"Previous ad request is being processed.";
            break;
            
        case AdMobAdPieAdErrorContentLoad: // 컨텐츠 로딩 실패 (웹뷰 컨텐츠 로딩 실패)
            description = @"An error occurred while loading content.";
            break;
            
        case AdMobAdPieAdErrorServerData: // 서버 데이터 오류 (데이터 파싱)
            description = @"A server data error occurred.";
            break;
            
        case AdMobAdPieAdErrorInvalidLayout: // 레이아웃 설정 오류 (배너의 경우 백그라운드 상태이거나 잘못된 슬롯 사이즈, 네이티브의 경우 필수 요소가 빠진 상태)
            description = @"Invalid ad layout.";
            break;
            
        case AdMobAdPieAdErrorLimitRequest: // 광고 요청의 시간 제한 (기존 요청의 시간 비교 후 서버 전송 없음)
            description = @"Ad request was blocked with minimum time limit.";
            break;
            
        case AdMobAdPieAdErrorNoMediationData: // 미디에이션 정보 없음
            description = @"No mediation data.";
            break;
            
        default:
            description = @"An unspecified error occurred.";
            break;
    }
    
    return description;
}

+ (NSError*)errorWithCode:(AdMobAdPieAdErrorCode)code {
    NSString *description = [AdMobAdPieAdError errorDescriptionWithCode:code];
    return [AdMobAdPieAdError errorWithCode:code description:description];
}

+ (NSError*)errorWithCode:(NSInteger)code description:(NSString *)description {
    return [AdMobAdPieAdError errorWithDomain:AdMobAdPieAdErrorDomain code:code description:description];
}

+ (NSError*)errorWithDomain:(NSString *)domain code:(AdMobAdPieAdErrorCode)code {
    NSString *description = [AdMobAdPieAdError errorDescriptionWithCode:code];
    return [AdMobAdPieAdError errorWithDomain:domain code:code description:description];
}

+ (NSError*)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    return [AdMobAdPieAdError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
