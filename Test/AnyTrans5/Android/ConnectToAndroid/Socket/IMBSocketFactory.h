//
//  IMBSocketFactory.h
//  
//
//  Created by ding ming on 17/3/16.
//
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "IMBPortTable.h"

@interface IMBSocketFactory : NSObject

+ (BOOL)getAsyncSocket:(NSString *)serialNumber withAsncSocket:(GCDAsyncSocket *)client;
+ (void)closeDisposeSocket:(GCDAsyncSocket *)client serialNumber:(NSString *)serialNumber;

@end
