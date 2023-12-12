//
//  APStoreKitAdImpression.h
//  AdPieSDK
//
//  Created by sunny on 2023/11/29.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APStoreKitAdImpression : NSObject

@property BOOL isReportedImpression;
@property SKAdImpression *skadImpression API_AVAILABLE(ios(14.5));

- (id) initWithDictionary:(NSDictionary *) skadn API_AVAILABLE(ios(14.5));

@end

NS_ASSUME_NONNULL_END
