//
//  IMBBaseDelete.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-4.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBTrack.h"
#import "IMBDeviceConnection.h"
#import "IMBATHSync.h"

@interface IMBBaseDelete : NSObject
{
    IMBiPod *_ipod;
    BOOL _isStop;
    NSMutableArray *_deleteArray;
    IMBLogManager *_logManager;
    id _delegate;
}
@property (nonatomic,assign) id delegate;

- (id)initWithIPod:(IMBiPod *)ipod deleteArray:(NSMutableArray *)deleteArray;
- (void)removeTrackByTrack:(IMBTrack*)track;
- (void)startDelete;
@end
