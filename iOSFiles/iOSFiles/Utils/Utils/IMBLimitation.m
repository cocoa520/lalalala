//
//  IMBLimitation.m
//  AllFiles
//
//  Created by iMobie on 2018/4/27.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBLimitation.h"

static IMBLimitation *_instance = nil;


NSString * const IMBLimitationRegisterStatus = @"IMBLimitationRegisterStatus";

@interface IMBLimitation()<NSCopying>

@end

@implementation IMBLimitation

#pragma mark - 
@synthesize leftToMacNums = _leftToMacNums;
@synthesize leftToDeviceNums = _leftToDeviceNums;
@synthesize leftToCloudNums = _leftToCloudNums;
@synthesize registerStatus = _registerStatus;


#pragma mark - 单例实现
+ (instancetype)sharedLimitation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)initializeConfigurationInfo {
    //初始存储限制个数信息
    if ([self getRestNumsWithType:IMBLimitationTypeToMac] == -1) {
        [self saveRestNumsWithNum:100 type:IMBLimitationTypeToMac];
        [self saveRestNumsWithNum:100 type:IMBLimitationTypeToDevice];
        [self saveRestNumsWithNum:100 type:IMBLimitationTypeToCloud];
    }
}
#pragma mark - methods
- (void)getRestNumsWithNum {
    _leftToMacNums = [self getRestNumsWithType:IMBLimitationTypeToMac];
    _leftToCloudNums = [self getRestNumsWithType:IMBLimitationTypeToCloud];
    _leftToDeviceNums = [self getRestNumsWithType:IMBLimitationTypeToDevice];
}
/**
 *  @return -1则为 错误信息
 */
- (int)getRestNumsWithType:(IMBLimitationType)type {
    NSString *restNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:[self getTypeStringWithType:type]];
    if (restNumStr) {
        return restNumStr.intValue;
    }else {
        return -1;
    }
}
- (void)saveRestNums {
    [self saveRestNumsWithNum:self.leftToMacNums type:IMBLimitationTypeToMac];
    [self saveRestNumsWithNum:self.leftToDeviceNums type:IMBLimitationTypeToDevice];
    [self saveRestNumsWithNum:self.leftToCloudNums type:IMBLimitationTypeToCloud];
}
/**
 *  存取剩余个数
 *  @param restNum 剩余个数
 */
- (void)saveRestNumsWithNum:(int)restNum type:(IMBLimitationType)type {
    
    [[NSUserDefaults standardUserDefaults] setObject:@(restNum) forKey:[self getTypeStringWithType:type]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  获取存取路径
 */
- (NSString *)getSavePath {
    NSString *savePath = NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, YES).lastObject;
    savePath = [savePath stringByAppendingPathComponent:@"AllFilesLimitation"];
    return savePath;
}

- (NSString *)getTypeStringWithType:(IMBLimitationType)type {
    switch (type) {
        case IMBLimitationTypeToMac:
        {
            return @"IMBLimitationTypeToMac";
        }
            break;
        case IMBLimitationTypeToDevice:
        {
            return @"IMBLimitationTypeToDevice";
        }
            break;
        case IMBLimitationTypeToCloud:
        {
            return @"IMBLimitationTypeToCloud";
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)setLeftToMacNums:(int)leftToMacNums {
    if (leftToMacNums < 0) {
        leftToMacNums = -1;
        _leftToMacNums = 0;
    }else {
        _leftToMacNums = leftToMacNums;
    }
    
    if (_registerStatus) {
        return;
    }
    if (leftToMacNums == 0) {
        [IMBNotiCenter postNotificationName:IMBLimitationNoti object:nil];
    }
    
}

- (void)setLeftToDeviceNums:(int)leftToDeviceNums {
    if (leftToDeviceNums < 0) {
        leftToDeviceNums = -1;
        _leftToMacNums = 0;
    }else {
        _leftToMacNums = leftToDeviceNums;
    }
    _leftToDeviceNums = leftToDeviceNums;
    if (_registerStatus) {
        return;
    }
    if (leftToDeviceNums == 0) {
        [IMBNotiCenter postNotificationName:IMBLimitationNoti object:nil];
    }
    
}

- (void)setLeftToCloudNums:(int)leftToCloudNums {
    if (leftToCloudNums < 0) {
        leftToCloudNums = -1;
        _leftToMacNums = 0;
    }else {
        _leftToMacNums = leftToCloudNums;
    }
    _leftToCloudNums = leftToCloudNums;
    if (_registerStatus) {
        return;
    }
    if (leftToCloudNums == 0) {
        [IMBNotiCenter postNotificationName:IMBLimitationNoti object:nil];
    }
   
}


- (void)saveRegisterStatus {
//    _registerStatus = 0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",_registerStatus] forKey:IMBLimitationRegisterStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getRegisterStatus {
    _registerStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:IMBLimitationRegisterStatus] intValue];
}


@end
