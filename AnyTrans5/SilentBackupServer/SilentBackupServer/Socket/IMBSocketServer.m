//
//  IMBSocketServer.m
//  PhoneCleanDeamon
//
//  Created by iMobie on 5/28/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import "IMBSocketServer.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation IMBSocketServer
@synthesize isListen = _isListen;
@synthesize currentUniquekey = _currentUniquekey;

+ (IMBSocketServer *)singleton {
    static IMBSocketServer *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBSocketServer alloc] init];
        }
    }
    return _singleton;
}

- (id)init {
    if (self = [super init]) {
        _isAccept = YES;
        _isListen = NO;
        _host = @"127.0.0.1";
        _port = 6888;
        _logManager = [IMBLogManager singleton];
//        _connectDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setPort:(int)port {
    _port = port;
}

- (id)initWithHost:(NSString *)host withPort:(int)port {
    if (self = [super init]) {
        _host = host;
        _port = port;
        _logManager = [IMBLogManager singleton];
    }
    return self;
}

- (BOOL)listenServer {
    unsigned long hostaddr;
    struct sockaddr_in servaddr;
    
    if (_host != nil && ![_host isEqualToString:@""]) {
        hostaddr = inet_addr([_host UTF8String]);
    } else {
        hostaddr = htonl(INADDR_LOOPBACK);
    }
    
    if( (_socketfd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP)) == -1 ){
        [_logManager writeInfoLog:[NSString stringWithFormat:@"create socket error: %s(errno: %d)",strerror(errno),errno]];
        return NO;
    }
    
    /* Enable address reuse */
    int on = 1;
    setsockopt(_socketfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
    
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = hostaddr;
    servaddr.sin_port = htons(_port);
    
    if( bind(_socketfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) == -1){
        [_logManager writeInfoLog:[NSString stringWithFormat:@"bind socket error: %s(errno: %d)",strerror(errno),errno]];
        close(_socketfd);
        return NO;
    }
    if( listen(_socketfd, 10) == -1){
        [_logManager writeInfoLog:[NSString stringWithFormat:@"listen socket error: %s(errno: %d)",strerror(errno),errno]];
        return NO;
    }
    return YES;
}

//调用之前先设置_currentUniquekey的值
- (void)acceptConnect:delegate {
    while (_isAccept) {
        int connfd;
        if((connfd = accept(_socketfd, (struct sockaddr*)NULL, NULL)) == -1){
            [_logManager writeInfoLog:[NSString stringWithFormat:@"accept socket error: %s(errno: %d)",strerror(errno),errno]];
            continue;
        }
        if (_connectClient != nil) {
//            [_connectClient closeConnectfd];
            [_connectClient release];
            _connectClient = nil;
        }
        _connectClient = [[IMBConnectClient alloc] initWithConnectClient:connfd withDelegate:delegate];
//        [_connectDic setValue:connectClient forKey:@"123"];
    }
}

//发送消息到client
- (void)sendDataToClient:(NSString *)str {
    if (_connectClient != nil) {
        [_connectClient sendData:str];
    }else {
//        NSLog(@"don't find connectfd");
    }
}

//接受消息从client
- (void)recvDataFromClient {
    if (_connectClient != nil) {
        [_connectClient recvDataByThread];
    }
}

- (void)recvData {
    ssize_t n;
    while (1) {
        if((_connfd = accept(_socketfd, (struct sockaddr*)NULL, NULL)) == -1){
            [_logManager writeInfoLog:[NSString stringWithFormat:@"accept socket error: %s(errno: %d)",strerror(errno),errno]];
            return;
        }
        while(1){
            @try {
                char buff[4096];
                n = recv(_connfd, buff, 4096, 0);
//                NSLog(@"recv msg from client: %s", buff);
//                NSLog(@"connfd:%d",_connfd);
            }
            @catch (NSException *exception) {
                close(_connfd);
                break;
            }
        }
    }
}

- (void)sendData {
    char sendline[4096] = "serverserverserver";
    if (send(_connfd, sendline, strlen(sendline), 0) < 0) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"send msg error: %s(errno: %d)",strerror(errno),errno]];
    }
}

- (void)closeSocketdfd:(int)socketfd {
    close(socketfd);
    _isAccept = NO;
}

@end
