//
//  OperationLImitation.h
//  AnyTrans
//
//  Created by LuoLei on 16-9-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PrivateSecretKey @"AnyTransPrivateKey"

@interface OperationLImitation : NSObject
{
    long long _remainderCount;  //剩余个数
    long long _remainderDays;   //剩余天数
    NSString *_limitStatus;     ///<试用限制状态
    NSString *_firstDate;
    BOOL _needLimit;
}

@property (nonatomic, readwrite, retain) NSString *limitStatus;

- (void)setNeedlimit:(BOOL)needLimit;
+ (OperationLImitation*)singleton;
//剩余个数-1
- (void)reduceRedmainderCount;
- (void)reduceRedmainderCount:(int)count;
- (long long)remainderCount;
- (long long)remainderDays;

//将数据同步到本地
- (void)save;
@end
