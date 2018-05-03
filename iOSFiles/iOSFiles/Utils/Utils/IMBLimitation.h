//
//  IMBLimitation.h
//  AllFiles
//
//  Created by iMobie on 2018/4/27.
//  Copyright © 2018年 iMobie. All rights reserved.
//  软件是否购买注册的限制类

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    IMBLimitationTypeToMac = 10011,
    IMBLimitationTypeToDevice,
    IMBLimitationTypeToCloud,
} IMBLimitationType;

@interface IMBLimitation : NSObject
{
    @private
    int _leftToMacNums;
    int _leftToDeviceNums;
    int _leftToCloudNums;
    
    int _registerStatus;
}

@property(nonatomic, assign)int leftToMacNums;
@property(nonatomic, assign)int leftToDeviceNums;
@property(nonatomic, assign)int leftToCloudNums;
@property(nonatomic, assign)int registerStatus;


+ (instancetype)sharedLimitation;

- (void)initializeConfigurationInfo;
/**
 *  获取所有的剩余数并进行对属性的赋值
 */
- (void)getRestNumsWithNum;
- (void)saveRestNums;
/**
 *  存取剩余个数
 *  @param restNum 剩余个数
 */
- (void)saveRestNumsWithNum:(int)restNum type:(IMBLimitationType)type;
/**
 *  @return -1则为 错误信息
 */
- (int)getRestNumsWithType:(IMBLimitationType)type;


- (void)saveRegisterStatus;
- (void)getRegisterStatus;

@end
