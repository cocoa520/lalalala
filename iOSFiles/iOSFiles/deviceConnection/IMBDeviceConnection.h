//
//  IMBDeviceConnection.h
//  iOSFiles
//
//  Created by iMobie on 18/1/16.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"

@interface IMBDeviceConnection : NSObject
{
    @private
    NSMutableArray *_serialArray;
}
@property(nonatomic, copy)void(^IMBDeviceConnected)(void);
@property(nonatomic, copy)void(^IMBDeviceDisconnected)(NSString *serialNum);
@property(nonatomic, copy)void(^IMBDeviceNeededPassword)(am_device device);

@property(nonatomic, retain, readonly)NSMutableArray *serialArray;

+ (instancetype)singleton;

- (void)startListening;
- (void)stopListening;

@end
