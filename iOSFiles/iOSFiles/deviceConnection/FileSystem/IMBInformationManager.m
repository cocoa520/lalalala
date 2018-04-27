//
//  IMBInformationManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-3-11.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBInformationManager.h"
//#import "RegexKitLite.h"
//#import "IMBDeviceInfo.h"
//#import "RegexKitLite.h"
//#import "IMBHelper.h"
//#import "IMBIPod.h"
//#import "IMBiCloudClient.h"
//#import "IMBInformation.h"
//#import "IMBProgressCounter.h"

static IMBInformationManager *sigleton = nil;
@implementation IMBInformationManager
@synthesize informationDic = _informationDic;
+ (IMBInformationManager *)shareInstance{
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[IMBInformationManager alloc] init];
        }
    }
    return sigleton;
}

- (id)init {
    if (self = [super init]) {
        _informationDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

- (void)dealloc
{
    [_informationDic release],_informationDic = nil;
    [super dealloc];
}
    
@end
