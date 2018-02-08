//
//  IMBConnectClient.h
//  PhoneClean
//
//  Created by iMobie on 6/1/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBLogManager.h"

@interface IMBConnectClient : NSObject {
    int _connectfd;
    BOOL _isRecv;
    IMBLogManager *_logManager;
    NSThread *_thread;
    id _delegate;
}

- (id)initWithConnectClient:(int)connectfd withDelegate:(id)delegate;

//向client发送消息
- (void)sendData:(NSString *)str;

//用于监听client发来的消息
- (void)recvDataByThread;

- (void)closeConnectfd;

@end
