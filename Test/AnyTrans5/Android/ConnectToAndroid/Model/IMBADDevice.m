//
//  IMBADDevice.m
//  
//
//  Created by ding ming on 17/3/17.
//
//

#import "IMBADDevice.h"
#include <stdio.h>
#import <string.h>
@implementation IMBADDevice

- (id)initWithSerialNumber:(NSString *)serialNumber WithDeviceInfo:(id)deviceInfo {
    self = [super init];
    if (self) {
        _serialNumber = serialNumber;
        _deviceInfo = deviceInfo;
    }
    return self;
}

#pragma mark - Abstract Method
- (int)queryDetailContent {
    [_loghandle writeInfoLog:@"Device queryDetailContent Begin"];
    int result = 0;
    dispatch_queue_t queue = /*dispatch_get_current_queue();/*/dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        NSString *jsonStr = [self createParamsjJsonCommand:DEVICE Operate:QUERY ParamDic:[NSDictionary dictionary]];
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            NSLog(@"send two item?");
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"msg:%@",msg);
//                    sleep(1);
                    NSDictionary *msgDic = [IMBFileHelper dictionaryWithJsonString:msg];
                    if (msgDic != nil && _deviceInfo != nil) {
                        if ([msgDic.allKeys containsObject:@"isRoot"]) {
                            id rootValue = [msgDic objectForKey:@"isRoot"];
                            if ([rootValue isKindOfClass:[NSNumber class]]) {
                                const char *pObjc = [(NSNumber *)rootValue objCType];
                                if (strcmp(pObjc, @encode(BOOL))) {
                                   _deviceInfo.isRoot = [[msgDic objectForKey:@"isRoot"] boolValue];
                                }
                            }
                        }
                        if ([msgDic.allKeys containsObject:@"androidVersion"]) {
                            _deviceInfo.devVersion = [msgDic objectForKey:@"androidVersion"];
                        }
                        if ([msgDic.allKeys containsObject:@"deviceBrand"]) {
                            _deviceInfo.deviceBrand = [msgDic objectForKey:@"deviceBrand"];
                        }
                        if ([msgDic.allKeys containsObject:@"deviceFirm"]) {
                            _deviceInfo.deviceFirm = [msgDic objectForKey:@"deviceFirm"];
                        }
                        if ([msgDic.allKeys containsObject:@"deviceModel"]) {
                            _deviceInfo.devModel = [msgDic objectForKey:@"deviceModel"];
                        }
                        if ([msgDic.allKeys containsObject:@"deviceName"]) {
                            _deviceInfo.devName = [msgDic objectForKey:@"deviceName"];
                        }
                        if ([msgDic.allKeys containsObject:@"imei"]) {
                            _deviceInfo.imei = [msgDic objectForKey:@"imei"];
                        }
                        if ([msgDic.allKeys containsObject:@"phoneNumber"]) {
                            _deviceInfo.phoneNumber = [msgDic objectForKey:@"phoneNumber"];
                        }
                        if ([msgDic.allKeys containsObject:@"screenSize"]) {
                            _deviceInfo.devScreenResolution = [msgDic objectForKey:@"screenSize"];
                        }
                        if ([msgDic.allKeys containsObject:@"pathDir"]) {
                            _deviceInfo.pathDir = [msgDic objectForKey:@"pathDir"];
                        }
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Device queryDetailContent Error"];
                }
                [msg release];
            }];
            NSLog(@"ret:%d",ret);
            if (!ret) {
                result = -3;
            }
        }else {
            result = -2;
        }
        
        NSString *storageJsonStr = [self createParamsjJsonCommand:DEVICE Operate:STORAGE ParamDic:[NSDictionary dictionary]];
        if (![IMBFileHelper stringIsNilOrEmpty:storageJsonStr]) {
            ret = [coreSocket launchRequestContent:storageJsonStr FinishBlock:^(NSData *data) {
                NSString *msg1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg1) {
                    NSLog(@"msg1:%@",msg1);
//                    sleep(1);
                    NSArray *msgArr = [IMBFileHelper dictionaryWithJsonString:msg1];
                    if (msgArr != nil) {
                        for (NSDictionary *msgDic in msgArr) {
                            if (msgDic != nil && [msgDic isKindOfClass:[NSDictionary class]]) {
                                StorageInfo *info = [[StorageInfo alloc] init];
                                if ([msgDic.allKeys containsObject:@"available"]) {
                                    info.availableSize = [[msgDic objectForKey:@"available"] longLongValue];
                                }
                                if ([msgDic.allKeys containsObject:@"storageKind"]) {
                                    info.storageKind = [msgDic objectForKey:@"storageKind"];
                                }
                                if ([msgDic.allKeys containsObject:@"totalSize"]) {
                                    info.totalSize = [[msgDic objectForKey:@"totalSize"] longLongValue];
                                }
                                if ([msgDic.allKeys containsObject:@"storagePath"]) {
                                    info.storagePath = [msgDic objectForKey:@"storagePath"];
                                }
                                [_deviceInfo.storageArr addObject:info];
                                [info release];
                            }
                        }
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Device Storage queryDetailContent Error"];
                }
                [msg1 release];
            }];
            if (!ret) {
//                result = -5;
            }
        }else {
//            result = -4;
        }
        
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        result = -1;
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    [_loghandle writeInfoLog:@"Device queryDetailContent End"];
    return result;
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr {
    return 0;
}

- (int)importContent:(NSArray *)importArr {
    return 0;
}

- (int)deleteContent:(NSArray *)deleteArr {
    return 0;
}

@end
