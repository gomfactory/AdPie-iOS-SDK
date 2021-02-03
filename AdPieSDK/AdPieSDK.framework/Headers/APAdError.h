//
//  APAdError.h
//  AdPieSDK
//
//  Created by sunny on 2016. 3. 4..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum APAdErrorCode {
    // 알 수 없는 오류
    APAdErrorUnknown = -1,

    // 광고 없음
    APNoFill = 100,
    // 요청 오류
    APInvalidRequest = 101,
    // 서버 오류
    APNetworkError = 102,
    // 인터넷 연결 오류
    APNoConnection = 103,
    // SDK 내부 오류
    APInternalError = 104,
    // SDK 초기화 미완료
    APSdkNotInitialize = 105,
    // 중복 요청
    APDuplicateRequest = 106,
    // 컨텐츠 로드 실패
    APContentLoadError = 107,
    // 서버 데이터 오류
    APServerDataError = 108,
    // 레이아웃 오류
    APInvalidLayout = 109,
    // 동일 광고 요청에 대한 제한
    APLimitRequest = 110
} APAdErrorCode;

extern NSString *const APAdDomain;

NSError *APAdNSErrorForUnknown(void);
NSError *APAdNSErrorForNoFill(void);
NSError *APAdNSErrorForInvalidRequest(void);
NSError *APAdNSErrorForNetworkError(void);
NSError *APAdNSErrorForNoConnection(void);
NSError *APAdNSErrorForInternalError(void);
NSError *APAdNSErrorForSdkNotInitialize(void);
NSError *APAdNSErrorForDuplicateRequest(void);
NSError *APAdNSErrorForContentLoadError(void);
NSError *APAdNSErrorForServerDataError(void);
NSError *APAdNSErrorForInvalidLayout(void);
NSError *APAdNSErrorForLimitRequest(void);
