//
//  IMBSocketClient.m
//  PhoneClean
//
//  Created by iMobie on 5/28/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import "IMBSocketClient.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "IMBDeviceConnection.h"
#import "IMBHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBSocketClient
@synthesize isConnect = _isConnect;

+ (IMBSocketClient *)singleton {
    static IMBSocketClient *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBSocketClient alloc] init];
        }
    }
    return _singleton;
}

- (id)init {
    if (self = [super init]) {
        _isConnect = NO;
        _isRecv = YES;
        _host = @"127.0.0.1";
        _port = 6888;
        _logManager = [IMBLogManager singleton];
    }
    return self;
}

- (id)initWithHost:(NSString *)host withPort:(int)port {
    if (self = [super init]) {
        _host = host;
        _port = port;
        
        _logManager = [IMBLogManager singleton];
    }
    return self;
}

- (BOOL)connectServer {
    struct sockaddr_in servaddr;
    unsigned long hostaddr;
    if (_host != nil && ![_host isEqualToString:@""]) {
        hostaddr = inet_addr([_host UTF8String]);
    } else {
        hostaddr = htonl(INADDR_LOOPBACK);
    }
    
    if( (_socketfd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP)) == -1){
        [_logManager writeInfoLog:[NSString stringWithFormat:@"create socket error: %s(errno: %d)",strerror(errno),errno]];
        return NO;
    }
    
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(_port);
    servaddr.sin_addr.s_addr = hostaddr;
    if(connect(_socketfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) == -1){
        [_logManager writeInfoLog:[NSString stringWithFormat:@"connect error: %s(errno: %d)",strerror(errno),errno]];
        return NO;
    }
    return YES;
}

- (void)sendData:(NSString *)str {
    const char *sendline = [str UTF8String];
    if (send(_socketfd, sendline, strlen(sendline), 0) < 0) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"send msg error: %s(errno: %d)",strerror(errno),errno]];
    }
}

- (void)recvData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ssize_t n;
        while (_isRecv) {
            @try {
                char buff[4096];
                memset(buff, 0, sizeof(buff));
                n = recv(_socketfd, buff, 4096, 0);
                if (n <= 0) {
                    close(_socketfd);
                    break;
                }
                NSLog(@"recv msg from server: %s",buff);
                NSString *recvStr = [[NSString alloc] initWithCString:(const char *)buff encoding:NSUTF8StringEncoding];
                usleep(10);
                NSDictionary *dic = [IMBHelper dictionaryWithJsonString:recvStr];
                NSString *curStatus = @"";
                if ([dic.allKeys containsObject:@"CurrentStatus"]) {
                    curStatus = [dic objectForKey:@"CurrentStatus"];
                }
                IMBDeviceConnection *devConnect = [IMBDeviceConnection singleton];
                //用通知的方式通知界面
                if ([curStatus isEqualToString:@"DeviceDisconnect"]) {
                    NSLog(@"WIFI Device Disconnect!");
                    [devConnect removeWIFIConnectDevice:dic];
                }else {
                    NSLog(@"CurrentStatus:%@",curStatus);
                    [devConnect addWIFIConnectDevice:dic];
                }
            }
            @catch (NSException *exception) {
                _isConnect = NO;
                close(_socketfd);
                _isRecv = NO;
                break;
            }
        }
    });
}

- (void)closeSocketdfd {
    _isConnect = NO;
    close(_socketfd);
    _isRecv = NO;
}


@end
