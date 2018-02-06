//
//  IMBDeleteApps.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-4.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeleteApps.h"
#import "IMBAppEntity.h"
#import "IMBApplicationManager.h"
@implementation IMBDeleteApps

- (void)startDelete
{
    @try {
        IMBApplicationManager *applicationManager = [[IMBApplicationManager alloc] initWithiPod:_ipod];
        for (IMBAppEntity *entity in _deleteArray) {
            if (_isStop) {
                return;
            }
            if ([applicationManager removeApplication:entity]) {
                NSLog(@"%@ 删除成功",entity.appName);
            }
        }

    }
    @catch (NSException *exception) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"DeleteApp exception:%@",exception]];

    }
    @finally {
        
    }
}
@end
