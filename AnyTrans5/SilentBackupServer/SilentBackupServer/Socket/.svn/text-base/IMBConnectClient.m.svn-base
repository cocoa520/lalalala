//
//  IMBConnectClient.m
//  PhoneClean
//
//  Created by iMobie on 6/1/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import "IMBConnectClient.h"
#import <sys/socket.h>
#import "IMBDeviceConnection.h"
#import "AppDelegate.h"

@implementation IMBConnectClient

- (id)initWithConnectClient:(int)connectfd withDelegate:(id)delegate {
    if (self) {
        _isRecv = YES;
        _delegate = delegate;
        _connectfd = connectfd;
        _logManager = [IMBLogManager singleton];
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(recvDataByThread) object:nil];
        [_thread start];
    }
    return self;
}

- (void)dealloc
{
    if (_thread != nil) {
        [_thread cancel];
        [_thread release];
        _thread = nil;
    }
    [super dealloc];
}

//用于监听client发来的消息
- (void)recvDataByThread {
    ssize_t n;
    while (_isRecv) {
        @try {
            char buff[4096];
            memset(buff, 0, sizeof(buff));
            n =  recv(_connectfd, buff, 4096, 0);
            if (n <= 0) {
                [self closeConnectfd];
                break;
            }
            printf("recv msg from client: %s/n", buff);
            NSLog(@"connfd:%d",_connectfd);
            
            NSString *recvStr = [[NSString alloc] initWithCString:(const char *)buff encoding:NSUTF8StringEncoding];
            //                usleep(10);
            NSDictionary *dic = [IMBHelper dictionaryWithJsonString:recvStr];
            NSString *msgType = @"";
            if ([dic.allKeys containsObject:@"MsgType"]) {
                msgType = [dic objectForKey:@"MsgType"];
            }
            if ([msgType isEqualToString:@"BackupNow"]) {//点击按钮开始备份消息
                if ([dic.allKeys containsObject:@"SerialNumber"]) {
                     NSString *serialNumber = [dic objectForKey:@"SerialNumber"];
                    [_delegate backupDeviceNow:serialNumber];
                }
            }else if ([msgType isEqualToString:@"AnyTransStart"]) {//Anytrans启动消息

            }else if ([msgType isEqualToString:@"CloseSocketd"]) {//关闭socket消息
                [[IMBDeviceConnection singleton].conArray removeAllObjects];
                [self closeConnectfd];
            }else if ([msgType hasPrefix:@"ChooseLanguage_"]) {
                NSString *str = [msgType substringFromIndex:15];
                [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:str, nil] forKey:@"AppleLanguages"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else if ([msgType isEqualToString:@"USBDeviceConnect"]) {
                if ([dic.allKeys containsObject:@"SerialNumber"]) {
                    NSString *serialNumber = [dic objectForKey:@"SerialNumber"];
                    [_delegate USBDeviceConnect:serialNumber];
                }
            }else if ([msgType isEqualToString:@"USBDeviceDisconnect"]) {
                if ([dic.allKeys containsObject:@"SerialNumber"]) {
                    NSString *serialNumber = [dic objectForKey:@"SerialNumber"];
                    [_delegate USBDeviceDisconnect:serialNumber];
                }
            }else if ([msgType isEqualToString:@"StopAirBackup"]) {
                if ([dic.allKeys containsObject:@"SerialNumber"]) {
                    NSString *serialNumber = [dic objectForKey:@"SerialNumber"];
                    [_delegate stopCurBackup:serialNumber];
                }
            }
        }
        @catch (NSException *exception) {
            _isRecv = NO;
            close(_connectfd);
            break;
        }
    }
}

//向client发送消息
- (void)sendData:(NSString *)str {
    const char *sendline = [str UTF8String];
    if (send(_connectfd, sendline, strlen(sendline), 0) < 0) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"send msg error: %s(errno: %d)",strerror(errno),errno]];
    }
}

- (void)closeConnectfd {
    close(_connectfd);
    _isRecv = NO;
}

@end
