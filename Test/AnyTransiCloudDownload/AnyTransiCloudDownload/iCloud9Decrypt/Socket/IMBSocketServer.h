//
//  IMBSocketServer.h
//  PhoneCleanDeamon
//
//  Created by iMobie on 5/28/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IMBLogManager.h"
#import "IMBConnectClient.h"

@interface IMBSocketServer : NSObject {
    int _socketfd;
    NSString *_host;
    int _port;
    int _connfd;
    
    BOOL _isListen;
    //    NSMutableDictionary *_connectDic;
    BOOL _isAccept;
    NSString *_currentUniquekey;
    IMBConnectClient *_connectClient;
    
    //    IMBLogManager *_logManager;
}
@property (nonatomic, readwrite) BOOL isListen;
@property (nonatomic, retain) NSString *currentUniquekey;

+ (IMBSocketServer *)singleton;

- (void)setPort:(int)port;

- (id)initWithHost:(NSString *)host withPort:(int)port;

- (BOOL)listenServer;

- (void)closeSocketdfd;

- (void)recvData;
- (void)sendData;

- (void)acceptConnect;
//发送消息到client
- (void)sendDataToClient:(NSString *)str;
//接受消息从client]
- (void)recvDataFromClient;

@end
