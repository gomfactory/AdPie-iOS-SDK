//
//  APBase64Util.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 26..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APBase64Util : NSObject

+ (NSString *)base64EncodedString:(NSString *)fromString;
+ (NSString *)base64EncodedStringWithUrlSafe:(NSString *)fromString;
+ (NSString *)base64EncodedStringFromData:(NSData *)fromData;
+ (NSString *)base64EncodedDataWithUrlSafe:(NSData *)fromData;
+ (NSString *)base64DecodedString:(NSString *)fromString;
+ (NSData *)base64DecodedData:(NSString *)fromString;
@end
