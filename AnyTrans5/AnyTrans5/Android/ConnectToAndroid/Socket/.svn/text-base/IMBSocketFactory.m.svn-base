//
//  IMBSocketFactory.m
//  
//
//  Created by ding ming on 17/3/16.
//
//

#import "IMBSocketFactory.h"
#import "IMBAdbManager.h"
//#import <IMBAndroidDevice/IMBAndroidDevice.h>
#import "IMBAndroidDevice.h"
//#import <IMBAndroidDevice/IMBAdbManager.h>
#import "IMBFileHelper.h"

static const NSString *ip = @"127.0.0.1";
@implementation IMBSocketFactory

/// <summary>
/// Create socket client.
/// </summary>
/// <param name="port">socket port</param>
/// <returns>Socket client</returns>
+ (BOOL)getAsyncSocket:(NSString *)serialNumber withAsncSocket:(GCDAsyncSocket *)client {
    IMBAdbManager *adbManager = [IMBAdbManager singleton];
    BOOL ret = NO;
    IMBPortItem *portItem= [IMBPortTable singleton].getPortItem;
    [client setPortItem:portItem];
    //这里进行一次端口重定向
    NSArray *array = [adbManager adbForwardTCP:serialNumber withTcpLocal:portItem.cPort withTcpRemote:portItem.sPort];
    NSString *str1 = [adbManager runADBCommand:array];
    NSLog(@"str1:%@",str1);
    
    NSError *error = nil;
    ret = [client connectToHost:(NSString *)ip onPort:portItem.sPort withTimeout:10 error:&error];
    if (ret) {
        NSLog(@"连接成功");
    }else {
        if (error) {
            NSLog(@"连接失败:%@",error);
        }
        NSLog(@"连接失败");
    }
//    if ([socketListenning rangeOfString:@"iMobieAndroid_Socket_Listenning"].location != NSNotFound) {
//    }else {
//        NSString *forceStopStr = [adbManager runADBCommand:[adbManager forceStopIntentWithSerialNo:serialNumber]];
//        NSLog(@"str:%@",forceStopStr);
//        NSString *clearServiceStr = [adbManager runGrepCommand:[adbManager clearServiceLogcat]];
//        if (![IMBFileHelper stringIsNilOrEmpty:clearServiceStr]) {
//            NSLog(@"clearServiceStr:%@",clearServiceStr);
//        }
//        [IMBSocketFactory getAsyncSocket:serialNumber withAsncSocket:client];
//    }
    return ret;
}

/// <summary>
/// Close connection and release socket's resource.
/// </summary>
+ (void)closeDisposeSocket:(GCDAsyncSocket *)client serialNumber:(NSString *)serialNumber {
    if (client != nil) {
        //归还端口都端口资源池
        IMBPortItem *point = client.getPortItem;
        if (point != nil) {
            IMBAdbManager *adbManager = [IMBAdbManager singleton];
            [adbManager runADBCommand:[adbManager adbForwardRemoveTcp:serialNumber withTcpLocal:point.cPort]];
            IMBPortTable *table = [IMBPortTable singleton];
            [table releasePort:point.portId];
        }
        
//        if (client.isConnected) {
            [client disconnect];
//        }
    }
}

@end
