//
//  IMBConnectClient.m
//  PhoneClean
//
//  Created by iMobie on 6/1/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import "IMBConnectClient.h"
#import <sys/socket.h>
//#import "IMBIPodPool.h"
#import "IMBHelper.h"
#import "iCloudClient.h"
#import "Device.h"
#import "SnapshotEx.h"
#import "IMBLogManager.h"
@implementation IMBConnectClient
static char buff[4096];
- (id)initWithConnectClient:(int)connectfd {
    if (self) {
        _isRecv = YES;
        _connectfd = connectfd;
        //        _logManager = [IMBLogManager singleton];
        conEntity = [[IMBConfigurationEntity alloc]init];
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
    if (conEntity != nil) {
        [conEntity release];
        conEntity = nil;
    }
    [super dealloc];
}

//用于监听client发来的消息
- (void)recvDataByThread {
    int n;
    @autoreleasepool {
        while (_isRecv) {
            @try {
                
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
                [recvStr release];
                recvStr = nil;
                if (dic == nil) {
                    
                    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"NOTIFY_iCloudData_NETWORK_FAIL", @"MsgType", nil];
                    NSString *str = [self dictionaryToJson:dic1];
                    [self sendData:str];
                    return;
                }
                NSString *msgType = @"";
                if (dic != nil) {
                    if ([dic.allKeys containsObject:@"MsgType"]) {
                        msgType = [dic objectForKey:@"MsgType"];
                    }
                    if ([msgType isEqualToString:@"icloudLogin"]) {
                        [conEntity loginIcloud:dic withConnectInt:_connectfd];
                    }else if ([msgType isEqualToString:@"icloudDownData"]){
                         dispatch_async(dispatch_get_global_queue(0, 0), ^{
                             [conEntity loadingData];
                            });
                    }else if ([msgType isEqualToString:@"startDown"]){
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [conEntity downIcloudData:dic];
                        });
                    }else if ([msgType isEqualToString:@"backIcloudLogin"]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeApp" object:self userInfo:nil];
                    }else if ([msgType isEqualToString:@"statrIcloud"]){
                        
                        //                    if (conEntity != nil) {
                        //                        [conEntity release];
                        //                        conEntity = nil;
                        //                    }
                        //                    conEntity = [[IMBConfigurationEntity alloc]init];
                    }else if ([msgType isEqualToString:@"appClose"]){
                        [conEntity stopDownIcloud];
                    }
                }else{
                    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"icloudLoginNetworkfail", @"MsgType", nil];
                    NSString *str = [self dictionaryToJson:dic1];
                    [self sendData:str];
                }
                
                //
                
                /*接收到的消息处理：（用单例实现下载类）
                 1、登录消息，通过接收到的登录账号和密码调用登录函数，并发送登录结果（是否登录成功的BOOL值）给客服端；
                 2、获取iCloud backup列表消息，直接调用获取backup信息函数，并发送返回的结果（可能是一个NSMutableDictionary）给客服端；
                 3、下载iCloud backup消息，通过接收到的backup的标记在列表中找到对应的backup，调用下载函数进行下载，并把返回的进度发送给客服端；
                 4、下载停止消息，把cancel变量设为YES；
                 5、退出消息；
                 */
            }
            @catch (NSException *exception) {
                _isRecv = NO;
                close(_connectfd);
                break;
            }
        }
    }
   
}
- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    @autoreleasepool {
        NSString *jsonStr = nil;
        if (dic != nil) {
            if ([NSJSONSerialization isValidJSONObject:dic]) {
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
                jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
                NSLog(@"jsonStr:%@",jsonStr);
            }
        }
        return jsonStr;
    }
}
//向client发送消息
- (void)sendData:(NSString *)str {
    @autoreleasepool {
        const char *sendline = [str UTF8String];
        if (send(_connectfd, sendline, strlen(sendline), 0) < 0) {
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"send msg error: %s(errno: %d)",strerror(errno),errno]];
        }
    }
}

- (void)closeConnectfd {
    close(_connectfd);
    _isRecv = NO;
}

@end
