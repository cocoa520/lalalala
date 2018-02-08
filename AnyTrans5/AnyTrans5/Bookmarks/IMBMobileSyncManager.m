//
//  IMBBaseManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBMobileSyncManager.h"

@implementation IMBMobileSyncManager
@synthesize allItemDic = _allItemDic;
@synthesize mobileSync;
- (id)initWithAMDevice:(AMDevice*)_device
{
    self = [super init];
    if (self) {
        _threadBreak = NO;
        nc = [NSNotificationCenter defaultCenter];
//        [nc addObserver:self selector:@selector(ejectiPod:) name:NOTIFY_IPOD_EJECT object:nil];
        device = [_device retain];
        if (!device.isValid) {
            _threadBreak = YES;
        }
    }
    return self;
}

- (id)initWithAMDeviceByexport:(AMDevice *)dev
{
    self = [super init];
    if (self) {
        device = [dev retain];
        _threadBreak = NO;
//        _softWareInfo = [IMBSoftWareInfo singleton];
        _transResult = [IMBResultSingleton singleton];
        _progressCounter = [IMBProgressCounter singleton];
        [_progressCounter reInit];
        [_transResult reInit];
        nc = [NSNotificationCenter defaultCenter];
//        [nc addObserver:self selector:@selector(changeThreadBreak:) name:NOTIFY_PROGRESS_SHOULD_CLOSE object:nil];
//        [nc addObserver:self selector:@selector(ejectiPod:) name:NOTIFY_IPOD_EJECT object:nil];
        if (!device.isValid) {
            _threadBreak = YES;
        }
    }
    
    return self;
}

- (void)changeThreadBreak:(NSNotification *)notification
{
    _threadBreak = YES;
}

- (void)ejectiPod:(NSNotification *)notification {
    if ([(NSString*)(notification.object) isEqualToString:device.serialNumber]) {
        _threadBreak = YES;
    }
}

+ (BOOL)checkItemsValidWithIPod:(IMBiPod *)ipod itemKey:(NSString *)itemKey{
    BOOL isPass = YES;
    NSDictionary *dataSyncStr = [ipod.deviceHandle deviceValueForKey:nil inDomain:@"com.apple.mobile.data_sync"];
    if (dataSyncStr != nil) {
        NSArray *allKey = [dataSyncStr allKeys];
        if ([allKey containsObject:itemKey]) {
            NSDictionary *contDic = [dataSyncStr objectForKey:itemKey];
            if (contDic != nil) {
//                NSArray *accountNamesInfoArray = [contDic objectForKey:@"AccountNames"];
//                if (accountNamesInfoArray != nil && [accountNamesInfoArray count] > 0) {
//                    for (NSString *item in accountNamesInfoArray) {
//                        if ([item isEqualToString:@"iCloud"]) {
//                            isPass = NO;
//                            break;
//                        }
//                    }
//                }
                
                if (isPass) {
                    NSArray *sourcesInfoArray = [contDic objectForKey:@"Sources"];
                    if (sourcesInfoArray != nil && [sourcesInfoArray count] > 0) {
                       // for (NSString *item in sourcesInfoArray) {
                         //   if ([item isEqualToString:@"iCloud"]) {
                                isPass = NO;
                               // break;
                            }
                        //}
                   // }
                }
            }
        }
    }
    return isPass;
}

- (NSString *)createDifferentfileNameinfolder:(NSString *)folder  filePath:(NSString *)filePath fileManager:(NSFileManager *)fileMan
{
    NSString *fileName = [filePath lastPathComponent];
    NSString *newfilePath = nil;
    NSArray *arr = [fileName componentsSeparatedByString:@"."];
    int i = 1;
    //没有扩展名
    if (arr.count == 1) {
        
        while (1) {
            
            newfilePath = [folder stringByAppendingFormat:@"/%@(%d)",fileName,i];
            if (![fileMan fileExistsAtPath:newfilePath]) {
                break;
            }
            i++;
        }
    }else //有扩展名
    {
        NSString *filename = nil;
        NSString *extensionname = nil;
        if (arr.count>=2) {
            
            filename = [arr objectAtIndex:0];
            extensionname = [arr objectAtIndex:1];
            
        }
        
        while (1) {
            
            newfilePath = [folder stringByAppendingFormat:@"/%@(%d).%@",filename,i,extensionname];
            if (![fileMan fileExistsAtPath:newfilePath]) {
                
                break;
                
            }
            
            i++;
            
        }
    }
    
    return newfilePath;
    
}

- (void)openMobileSync {
    if (mobileSync==nil) {
        int i = 0;
        while (mobileSync == nil) {
            i ++;
            usleep(200);
            mobileSync = [[device newAMMobileSync] retain];
            if (i > 100) {
                break;
            }
        }
    }else
    {
        [mobileSync disConnectService];
        [mobileSync release];
        mobileSync = [[device newAMMobileSync] retain];
    }
    
    
//    [self closeMobileSync];
}

- (void)closeMobileSync {
    if (mobileSync != nil) {
        [mobileSync disConnectService];
        [mobileSync release];
        mobileSync = nil;
    }
}

- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	[formatter release];
	
    return str;
}

- (void)dealloc
{
//    [nc removeObserver:self name:NOTIFY_PROGRESS_SHOULD_CLOSE object:nil];
//    [nc removeObserver:self name:NOTIFY_IPOD_EJECT object:nil];
    if (device != nil) {
        [device release];
        device = nil;
    }
    [_allItemDic release];
    [super dealloc];
}

@end
