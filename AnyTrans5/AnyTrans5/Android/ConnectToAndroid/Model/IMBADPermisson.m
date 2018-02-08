//
//  IMBADPermisson.m
//  PhoneRescue_Android
//
//  Created by iMobie on 4/17/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBADPermisson.h"

@implementation IMBADPermisson

- (BOOL)checkDevicePermisson {
    [_loghandle writeInfoLog:@"checkDevicePermisson Begin"];
    _isGranted = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSDictionary *paramDic = [NSDictionary dictionary];
        NSString *jsonStr = [self createParamsjJsonCommand:RequestPermission Operate:QUERY ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerAction:) userInfo:scoket repeats:NO];
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"msg:%@",msg);
                    if ([msg isEqualToString:@"0000"]) {
                        _isGranted = YES;
                    }else {
                        
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"checkDevicePermisson Error"];
                }
                [msg release];
            }];
            if (timer.isValid) {
                [timer invalidate];
                timer = nil;
            }
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    
    [_loghandle writeInfoLog:@"checkDevicePermisson End"];
    return _isGranted;
}

- (void)promptToDeviceSetPermisson {
    [_loghandle writeInfoLog:@"promptToDeviceSetPermisson Begin"];
    
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSDictionary *paramDic = [NSDictionary dictionary];
        NSString *jsonStr = [self createParamsjJsonCommand:SETAPKPERMISSION Operate:QUERY ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:scoket repeats:NO];
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"msg:%@",msg);
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"promptToDeviceSetPermisson Error"];
                }
                [msg release];
            }];
            if (timer.isValid) {
                [timer invalidate];
                timer = nil;
            }
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    
    [_loghandle writeInfoLog:@"promptToDeviceSetPermisson End"];
}

- (void)timerAction:(NSTimer *)timer {
    GCDAsyncSocket *scoket = timer.userInfo;
    if (scoket != nil) {
        _isGranted = YES;
        [scoket disconnect];
    }
}

//检查我们软件apk是否执为短信接收默认APP
- (BOOL)checkIsSetSMSImport {
    [_loghandle writeInfoLog:@"check Is Set SMS Import Begin"];
    _isSetSMSApp = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSDictionary *paramDic = [NSDictionary dictionary];
        NSString *jsonStr = [self createParamsjJsonCommand:SMS Operate:CHECKSMSDEFAPP ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"msg:%@",msg);
                    if ([msg isEqualToString:@"0000"]) {
                        _isSetSMSApp = YES;
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"checkIsSetSMSImport Error"];
                }
                [msg release];
            }];
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    
    [_loghandle writeInfoLog:@"check Is Set SMS Import End"];
    return _isSetSMSApp;
}

//发送行为
- (void)sendAction:(NSString *)switchView ResultText:(int)resultCount TargetWord:(NSString *)target {
    [_loghandle writeInfoLog:@"sendAction Begin"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:switchView forKey:@"pageName"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",resultCount] forKey:@"result"];
    [paramDic setObject:target forKey:@"target"];
    NSString *jsonStr = [self createParamsjJsonCommand:APK Operate:SWITCH ParamDic:paramDic];
    if (![IMBHelper stringIsNilOrEmpty:jsonStr]) {
        dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
        GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
        BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
        if (ret) {
            IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
            [coreSocket setThread:[NSThread currentThread]];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerAction:) userInfo:scoket repeats:NO];
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"msg:%@",msg);
                }else {
                    [_loghandle writeInfoLog:@"sendAction Error"];
                }
                [msg release];
            }];
            if (timer.isValid) {
                [timer invalidate];
                timer = nil;
            }
            //关闭连接并释放端口
            [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
            [scoket release];
            [coreSocket release];
        }else {
            //关闭连接并释放端口
            [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
            [scoket release];
        }
    }
    [_loghandle writeInfoLog:@"sendAction End"];
}

//检查设备是否root
- (BOOL)checkDeviceIsRoot {
    [_loghandle writeInfoLog:@"checkDeviceIsRoot Begin"];
    __block BOOL isRoot = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSDictionary *paramDic = [NSDictionary dictionary];
        NSString *jsonStr = [self createParamsjJsonCommand:DEVICE Operate:ROOTSTATE ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"msg:%@",msg);
                    if ([msg isEqualToString:@"0000"]) {
                        isRoot = YES;
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"checkDeviceIsRoot Error"];
                }
                [msg release];
            }];
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    
    [_loghandle writeInfoLog:@"checkDeviceIsRoot End"];
    return isRoot;
}

//与服务器握手
- (BOOL)shakehandApk {
    [_loghandle writeInfoLog:@"shakehandApk Begin"];
    __block BOOL isSuccess = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSDictionary *paramDic = [NSDictionary dictionary];
        NSString *jsonStr = [self createParamsjJsonCommand:DEVICE Operate:SHAKEHAND ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"msg:%@",msg);
                    if ([msg isEqualToString:@"0000"]) {
                        isSuccess = YES;
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"shakehandApk Error"];
                }
                [msg release];
            }];
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    
    [_loghandle writeInfoLog:@"shakehandApk End"];
    return isSuccess;
}


@end
