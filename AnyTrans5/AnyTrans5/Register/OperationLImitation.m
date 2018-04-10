//
//  OperationLImitation.m
//  AnyTrans
//
//  Created by LuoLei on 16-9-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "OperationLImitation.h"
#import "TempHelper.h"
#import "DateHelper.h"
#define Limit_Day_Key @"limitDay"
#define Limit_Count_Key @"itemCount"
#import "NSString+Category.h"
#import "IMBSoftWareInfo.h"
@implementation OperationLImitation
@synthesize limitStatus = _limitStatus;

- (instancetype)init
{
    self = [super init];
    _needLimit = YES;
    if (self) {
        NSString *path = [TempHelper resourcePathOfAppDir:@"IMBSoftware-Info" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *allKeys = dic.allKeys;
        if ([allKeys containsObject:@"limit"]) {
            NSMutableDictionary *limitDic = [dic objectForKey:@"limit"];
            NSArray *subAllKeys = limitDic.allKeys;
            if (subAllKeys != nil && subAllKeys.count > 0) {
                if ([subAllKeys containsObject:Limit_Count_Key]) {
                    NSString *countLimit = (NSString*)[limitDic objectForKey:Limit_Count_Key];
                    _remainderCount = [[countLimit AES256DecryptWithKey:PrivateSecretKey] intValue];
                } else {
                   _remainderCount = 50;
                }
                if ([subAllKeys containsObject:Limit_Day_Key]) {
                    NSString *timeLimit = (NSString*)[limitDic objectForKey:Limit_Day_Key];
                    _remainderDays = [[timeLimit AES256DecryptWithKey:PrivateSecretKey] intValue];
                } else {
                    _remainderDays = 7;
                }
            } else {
                _remainderCount = 50;
                _remainderDays = 7;
            }
        } else {
            _remainderCount = 50;
            _remainderDays = 7;
        }
        NSString *currentDate = nil;
        NSString *currentDate1 = nil;
        NSString *dateStr = (NSString*)[dic objectForKey:@"FirstRunDate"];
        if (dateStr.length>0) {
            dateStr = [dateStr AES256DecryptWithKey:PrivateSecretKey];
            _firstDate = [dateStr retain];
        }else{
            _firstDate =  [[DateHelper stringFromFomate:[NSDate date] formate:@"yyyyMMdd"] retain];
        }
        
        NSString *currentdateStr = (NSString*)[dic objectForKey:@"currentDate"];
        if (currentdateStr.length>0) {
            currentdateStr = [currentdateStr AES256DecryptWithKey:PrivateSecretKey];
            currentDate1 = currentdateStr;
        }else{
            currentDate1 =  [DateHelper stringFromFomate:[NSDate date] formate:@"yyyyMMdd"];
        }
        //设置当前时间
        currentDate = [DateHelper stringFromFomate:[NSDate date] formate:@"yyyyMMdd"];
        NSDate *firstD = [DateHelper dateFromString:_firstDate Formate:@"yyyyMMdd"];
        NSTimeInterval firstInterval = [firstD timeIntervalSince1970];
        NSTimeInterval currentInterval = [[DateHelper dateFromString:currentDate Formate:@"yyyyMMdd"] timeIntervalSince1970];
        if ([_firstDate isVersionLessEqual:currentDate]&&(currentInterval - firstInterval)>=7*3600*24) {
            _remainderDays = 0;
            _remainderCount = 0;
        }else if ([_firstDate isVersionLessEqual:currentDate]&&(currentInterval - firstInterval)<7*3600*24){
            if ([currentDate isVersionMajor:currentDate1]) {
                _remainderCount = 50;
                _remainderDays = 7 - (currentInterval - firstInterval)/(3600*24);
            }
        }else{
            _remainderDays = 0;
            _remainderCount = 0;
        }
    }
    return self;
}

+ (OperationLImitation*)singleton {
    static OperationLImitation *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[OperationLImitation alloc] init];
		}
	}
	return _singleton;
}

- (void)save
{
    NSString *path = [TempHelper resourcePathOfAppDir:@"IMBSoftware-Info" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSMutableDictionary *limdic = [dic objectForKey:@"limit"];
    if (limdic != nil) {
        [limdic setValue:[[NSString stringWithFormat:@"%lld",_remainderCount] AES256EncryptWithKey:PrivateSecretKey] forKey:Limit_Count_Key];
        [limdic setValue:[[NSString stringWithFormat:@"%lld",_remainderDays] AES256EncryptWithKey:PrivateSecretKey] forKey:Limit_Day_Key];
        [limdic setValue:@"timelimit" forKey:@"limitType"];

        [dic setValue:limdic forKey:@"limit"];
    }else{
        limdic = [NSMutableDictionary dictionary];
        [limdic setValue:[[NSString stringWithFormat:@"%lld",_remainderCount] AES256EncryptWithKey:PrivateSecretKey] forKey:Limit_Count_Key];
        [limdic setValue:[[NSString stringWithFormat:@"%lld",_remainderDays] AES256EncryptWithKey:PrivateSecretKey] forKey:Limit_Day_Key];
        [limdic setValue:@"timelimit" forKey:@"limitType"];
        [dic setValue:limdic forKey:@"limit"];
    }
    NSString *currentdate =  [DateHelper stringFromFomate:[NSDate date] formate:@"yyyyMMdd"];
    [dic setValue:[currentdate AES256EncryptWithKey:PrivateSecretKey] forKey:@"currentDate"];
    [dic setValue:[_firstDate AES256EncryptWithKey:PrivateSecretKey] forKey:@"FirstRunDate"];
    [dic writeToFile:path atomically:YES];
}

- (void)reduceRedmainderCount
{
    if (_needLimit) {
        _remainderCount--;
    }
    if (_remainderCount <= 0) {
        _remainderCount = 0;
    }
}

- (void)reduceRedmainderCount:(int)count {
    if (_needLimit) {
        _remainderCount -= count;
    }
    if (_remainderCount <= 0) {
        _remainderCount = 0;
    }
}

- (long long)remainderCount
{
    if ([IMBSoftWareInfo singleton].isRegistered) {
        return NSIntegerMax;
    }else{
        if (_needLimit) {
            return _remainderCount;

        }else{
            return NSIntegerMax;
        }
    }
}

- (void)setNeedlimit:(BOOL)needLimit
{
    _needLimit = needLimit;
}


- (long long)remainderDays
{
    return _remainderDays;
}

- (void)dealloc
{
    [_firstDate release],_firstDate = nil;
    [super dealloc];
}

@end
