//
//  ATHHostSync32.m
//  ATHHostSync32
//
//  Created by LuoLei on 2017-03-24.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "ATHHostSync32.h"
#import "AirTrafficHost.h"
@implementation ATHHostSync32

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(accepAirSyncMessage:) name:Notify_AirSyncServiceMessage object:nil];
    }
    return self;
}

- (void)accepAirSyncMessage:(NSNotification *)notification
{
    NSString *type = notification.object; //消息类型
    if ([type isEqualToString:@"1"]) {
        _distantObject = [(IMBDistantObject *)[NSConnection rootProxyForConnectionWithRegisteredName:AirSyncServiceDistantObject host:nil] retain];
        _iTunesVersion = [[notification.userInfo objectForKey:@"iTunesVersion"] retain];
        NSString *serialNumberForHashing = [notification.userInfo objectForKey:@"serialNumberForHashing"];
        [self createAirSyncService:_iTunesVersion SerialNumberForHashing:serialNumberForHashing];
    }else if ([type isEqualToString:@"2"]){
        NSDictionary *inmutableSyncDict = [notification.userInfo objectForKey:@"inmutableSyncDict"];
        [self sendRequestSync:inmutableSyncDict];
    }else if ([type isEqualToString:@"3"]){
        NSDictionary *inmutableKeyBagDic = [notification.userInfo objectForKey:@"inmutableKeyBagDic"];
        NSDictionary *inmutableMediaSessionDic = [notification.userInfo objectForKey:@"inmutableMediaSessionDic"];
        [self createPlistAndCigSendDataSync:inmutableKeyBagDic InmutableMediaSessionDic:inmutableMediaSessionDic];
    }else if ([type isEqualToString:@"4"]){
        NSString *assetID = [notification.userInfo objectForKey:@"assetID"];
        NSString *mediaType = [notification.userInfo objectForKey:@"mediaType"];
        NSString *filePath = [notification.userInfo objectForKey:@"filePath"];
        [self sendFileComplete:assetID WithType:mediaType WithPath:filePath];
    }else if ([type isEqualToString:@"5"]){
        [self stopAirSyncService];
    }else if ([type isEqualToString:@"6"]){
        BOOL pingValue = [[notification.userInfo objectForKey:@"pingValue"] boolValue];
        [self needPingMessage:pingValue];
    }else if ([type isEqualToString:@"7"]){
        
        NSString *assetID = [notification.userInfo objectForKey:@"assetID"];
        NSString *mediaType = [notification.userInfo objectForKey:@"mediaType"];
        [self sendFileErrorComplete:assetID WithType:mediaType];
    }
}

- (BOOL)isVersionMajorEqual:(NSString *)verStr   SelfStr:(NSString *)selfStr{
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([selfStr compare:verStr options:NSNumericSearch] == NSOrderedDescending) || ([selfStr compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

//开启同步服务
- (void)createAirSyncService:(NSString *)iTunesVersion SerialNumberForHashing:(NSString *)serialNumberForHashing
{
    if (iTunesVersion.length == 0) {
        iTunesVersion = @"11.3";
    }
    //开始进行ATH处理
    //1.ATHostConnectionCreateWithLibrary

    _threadValue = ATHostConnectionCreateWithLibrary((void*)(CFStringRef)iTunesVersion, (void*)(CFStringRef)serialNumberForHashing, 0);
    if(_threadValue == 0){
        if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
            [_distantObject airSyncResult:NO];
        }
    }

    int res = 0;
    //2.Host PowerAssertion
    res = ATHostConnectionSendPowerAssertion(_threadValue, (void *)kCFBooleanTrue);

    //3.ConnectRetain
    if ([self isVersionMajorEqual:@"12.6.3" SelfStr:_iTunesVersion]) {
        if (res != 0) {
            res = ATHostConnectionRetain(_threadValue);
        }else {
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:NO];
            }
        }
    }else{
        if (res == 0) {
            res = ATHostConnectionRetain(_threadValue);
        }else {
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:NO];
            }
        }
    }
    //4.ATHostConnectionSendHostInfo
    if (res == 0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:iTunesVersion forKey:@"LibraryID"];
        NSString *hostName =  [[NSHost currentHost] localizedName];
        [dic setValue:hostName forKey:@"SyncHostName"];
        [dic setValue:[NSMutableArray array] forKey:@"SyncedDataclasses"];
        [dic setValue:iTunesVersion forKey:@"Version"];
        res = ATHostConnectionSendHostInfo(_threadValue, (void*)(CFDictionaryRef)dic);
        [dic release];
    }else if (res != 0){
        if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
            [_distantObject airSyncResult:NO];
        }
    }
    
    if ([self isVersionMajorEqual:@"12.6.3" SelfStr:_iTunesVersion]) {
        if (res == 0) {
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:NO];
            }
        }else{
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:YES];
            }
            //开启线程监听设备返回的消息
            [self monitorDeviceBackMessage];
        }

    }else{
        if (res != 0) {
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:NO];
            }
        }else{
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:YES];
            }
            //开启线程监听设备返回的消息
            [self monitorDeviceBackMessage];
        }

    }
}

- (void)stopAirSyncService
{
    ATHostConnectionInvalidate(_threadValue);
    ATHostConnectionRelease(_threadValue);
    _isStop = YES;
    _needPing = NO;
}
//后台监听设备消息
- (void)monitorDeviceBackMessage
{
    //开启线程 等待设备返回消息
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSString* msg = @"";
            while (!_isStop) {
                if (_isStop) {
                    break;
                }
                int64_t msgid = ATHostConnectionReadMessage(_threadValue);
                if (msgid != 0) {
                    msg = (NSString*)ATCFMessageGetName(msgid);
                    if ([_distantObject respondsToSelector:@selector(deviceBackMessage: MessageID:)]) {
                        [_distantObject deviceBackMessage:msg MessageID:msgid];
                    }
                }
            }
        }
    });
}

- (void)needPingMessage:(BOOL)needPingMessage
{
    if (needPingMessage) {
        _needPing = YES;
        [self pingMessage];
    }else{
        _needPing = NO;
    }
}

- (void)sendRequestSync:(NSDictionary *)inmutableSyncDict
{
    int64_t sessionId = ATHostConnectionGetCurrentSessionNumber(_threadValue);
    void* dicRef = ATCFMessageCreate(sessionId,(void *)(CFStringRef)@"RequestingSync",(void *)(CFDictionaryRef *)inmutableSyncDict);
    CFStringRef strRef = nil;
    strRef = (CFStringRef)dicRef;
    if (_isStop) {
        if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
            [_distantObject airSyncResult:NO];
        }
    }
    //最后把送过去
    int res = ATHostConnectionSendMessage(_threadValue, dicRef);
    if (res == 0) {
        //成功
        if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
            [_distantObject airSyncResult:YES];
        }
        
    }else{
        //失败
        if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
            [_distantObject airSyncResult:NO];
        }
    }

}

- (void)createPlistAndCigSendDataSync:(NSDictionary *)inmutableKeyBagDic InmutableMediaSessionDic:(NSDictionary *)inmutableMediaSessionDic
{
    int res = -1;
    res = ATHostConnectionSendMetadataSyncFinished(_threadValue, (id)(CFDictionaryRef)inmutableKeyBagDic, (id)(CFDictionaryRef)inmutableMediaSessionDic);
#if __x86_64__
    if ([self isVersionMajorEqual:@"12.6.3" SelfStr:_iTunesVersion]) {
        if (res != 0) {
            //成功
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:YES];
            }
        }else{
            //失败
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:NO];
            }
        }

    }else{
        if (res == 0) {
            //成功
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:YES];
            }
        }else{
            //失败
            if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
                [_distantObject airSyncResult:NO];
            }
        }

    }
    #else
    if (res != 0) {
        //成功
        if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
            [_distantObject airSyncResult:YES];
        }
    }else{
        //失败
        if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
            [_distantObject airSyncResult:NO];
        }
    }
#endif
}
-(void)sendFileComplete:(NSString*) assetID WithType:(NSString*)mediaType WithPath:(NSString*)filePath
{
    ATHostConnectionSendAssetCompleted(_threadValue, (void*)(CFStringRef)assetID, (void*)(CFStringRef)mediaType, (void*)(CFStringRef)filePath);
    if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
        [_distantObject airSyncResult:YES];
    }
}

-(void)sendFileErrorComplete:(NSString*) assetID WithType:(NSString*)mediaType
{
    ATHostConnectionSendFileError(_threadValue, (id)(CFStringRef)assetID, (id)(CFStringRef)mediaType, 3);
    if ([_distantObject respondsToSelector:@selector(airSyncResult:)]) {
        [_distantObject airSyncResult:YES];
    }
}

//开启一个线程ping消息，防止同步中断
- (void)pingMessage
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (_needPing) {
            if (_threadValue != 0) {
                ATHostConnectionSendPing(_threadValue);
            }
            sleep(2);
        }
    });
}

-(void)dealloc
{
    [_distantObject release];
    [_iTunesVersion release],_iTunesVersion = nil;
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:Notify_AirSyncServiceMessage object:nil];
    [super dealloc];
}
@end
