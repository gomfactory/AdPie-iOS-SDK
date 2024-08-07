//
//  APTargetingData.h
//  AdPieSDK
//
//  Created by sunny on 2016. 5. 18..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APTargetingData : NSObject

typedef enum APGender {
    AP_GENDER_FEMALE = 1,
    AP_GENDER_MALE = 2,
    AP_GENDER_UNKNOWN = 3

} APGender;

@property APGender gender;
@property int yearOfBirthday;
@property int age;
@property NSData *customData;

+ (instancetype)sharedInstance;

@end
