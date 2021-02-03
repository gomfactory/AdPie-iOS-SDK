//
//  APRequest.h
//  AdPieSDK
//
//  Created by sunny on 2016. 4. 1..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APRequest : NSObject

// Media ID
@property(nonatomic) NSString *appID;
// Slot ID
@property(nonatomic) NSString *slotID;
// Device type
@property(nonatomic) NSString *deviceType;
// OS type
@property(nonatomic) NSString *osType;
// UDID
@property(nonatomic) NSString *udid;
// UDID TYPE
@property(nonatomic) NSString *udidType;
// Do Not Tracking
@property(nonatomic) BOOL doNotTracking;
// Service Provider
@property(nonatomic) NSString *serviceProvider;
// Connection Type
@property(nonatomic) int connectionType;
// Mobile Country Code
@property(nonatomic) NSString *countryCode;
// System Language
@property(nonatomic) NSString *language;
// Manufacturer Name
@property(nonatomic) NSString *manufacturer;
// Model Name
@property(nonatomic) NSString *model;
// OS Version
@property(nonatomic) NSString *osVersion;
// SDK Version
@property(nonatomic) NSString *sdkVersion;
// UserAgent
@property(nonatomic) NSString *userAgent;
// Access Date
@property(nonatomic) NSString *accessDate;
// App Package Name
@property(nonatomic) NSString *appPackageName;
// App Version Name
@property(nonatomic) NSString *appVersionName;
// Device Width
@property(nonatomic) int deviceWidth;
// Device Height
@property(nonatomic) int deviceHeight;
// Vender ID
@property(nonatomic) NSString *venderId;
// User's Data - gender
@property(nonatomic) NSString *gender;
// User's Data - longitude (경도)
@property(nonatomic) double longitude;
// User's Data - latitude (위도)
@property(nonatomic) double latitude;
// User's Data - year of birthday
@property(nonatomic) int yearOfBirthday;
// User's Data - keywords
@property(nonatomic) NSString *keywords;

- (NSMutableDictionary *)commonData;
- (NSMutableDictionary *)configData;
- (NSMutableDictionary *)requestData:(NSString *)slotID transport:(BOOL)isSecurity;
- (NSMutableDictionary *)packageData:(NSString *)appData;

@end
