//
//  IMBSocketClient.h
//  PhoneClean
//
//  Created by iMobie on 5/28/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBLogManager.h"

@interface IMBSocketClient : NSObject {
    int _socketfd;
    NSString *_host;
    int _port;
    BOOL _isRecv;
    BOOL _isConnect;
    
    IMBLogManager *_logManager;
}
@property (nonatomic, assign) BOOL isConnect;

+ (IMBSocketClient *)singleton;

- (id)initWithHost:(NSString *)host withPort:(int)port;

- (BOOL)connectServer;

- (void)sendData:(NSString *)str;

- (void)recvData;

- (void)closeSocketdfd;

@end
