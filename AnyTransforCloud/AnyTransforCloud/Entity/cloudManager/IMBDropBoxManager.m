//
//  IMBDropBoxManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBDropBoxManager.h"

@implementation IMBDropBoxManager

- (void)loadData {
    [_baseDrive getList:@"0" success:^(DriveAPIResponse *response) {
        
    } fail:^(DriveAPIResponse *response) {
        
    }];
}
@end
