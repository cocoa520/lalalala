//
//  IMBDistantObject.h
//  AnyTrans
//
//  Created by LuoLei on 2017-03-27.
//  Copyright (c) 2017 imobie. All rights reserved.
//

@protocol AirSyncDelegate <NSObject>

//返回同步服务请求结果，是否开起成功
- (void)airSyncResult:(BOOL)isSuccess;
- (void)deviceBackMessage:(NSString *)message MessageID:(id)msgid;

@end
static  NSString *Notify_AirSyncServiceMessage = @"notify_AirSyncServiceMessage";  //开启同步服务通知
static  NSString *Notify_AirSyncServiceStartSuccess = @"Notify_AirSyncServiceStartSuccess";  //开启同步服务通知

static  NSString *AirSyncServiceDistantObject = @"AirSyncServiceDistantObject";

#import <Foundation/Foundation.h>
@interface IMBDistantObject : NSObject<AirSyncDelegate>

@end
