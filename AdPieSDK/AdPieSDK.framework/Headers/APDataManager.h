//
//  APDataManager.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 20..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APRequest.h"

// Common
#define ADPIE_KEY_CONFIG_URL @"com.gomfactory.adpie.config_url"
#define ADPIE_KEY_SSP_URL @"com.gomfactory.adpie.ssp_url"
#define ADPIE_KEY_USERAGENT @"com.gomfactory.adpie.useragent"
#define ADPIE_KEY_LOG_ENABLE @"com.gomfactory.adpie.log_enable"

// Media
#define ADPIE_KEY_SSP_ENABLE @"com.gomfactory.adpie.ssp_enable"
#define ADPIE_KEY_ACCESS_DATE @"com.gomfactory.adpie.access_date"
#define ADPIE_KEY_CONFIG_UPDATE_DATE @"com.gomfactory.adpie.config_update_date"

// Slot
#define ADPIE_KEY_RESPONSE_INTERVAL @"com.gomfactory.adpie.reponse_interval"
#define ADPIE_KEY_REQUEST_TIME @"com.gomfactory.adpie.request_time"
#define ADPIE_KEY_REQUEST_LIMIT_INTERVAL @"com.gomfactory.adpie.request_limit_interval"

@interface APDataManager : NSObject

@property(nonatomic) APRequest *request;

@property(nonatomic, readonly) BOOL isServerLog;
@property(nonatomic, readonly) NSString *configUrl;
@property(nonatomic, readonly) NSString *sspUrl;

+ (instancetype)sharedInstance;

- (void)configuration:(NSData *)data;

- (void)setKey:(NSString *)key withValue:(NSString *)value;
- (NSString *)getValue:(NSString *)key withDefault:(NSString *)defaultValue;
- (void)setKey:(NSString *)key withNumberValue:(NSNumber *)value;
- (NSNumber *)getNumberValue:(NSString *)key
                 withDefault:(NSNumber *)defaultValue;
- (void)setKey:(NSString *)key withDateValue:(NSDate *)value;
- (NSDate *)getDateValue:(NSString *)key withDefault:(NSDate *)defaultValue;
- (void)setKey:(NSString *)key withBoolValue:(BOOL)value;
- (BOOL)getBoolValue:(NSString *)key;

@end
