//
//  IMBSyncPlaylistFactory.h
//  iMobieTrans
//
//  Created by Pallas on 1/28/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBISyncPlaylistToCDB : NSObject

// 同步处理函数
- (void)startSync;

// 清理文件
- (void)cleanup;

@end

@class IMBiPod;

@interface IMBSyncPlaylistFactory : NSObject

+ (IMBISyncPlaylistToCDB*)getSyncInstance:(IMBiPod*)ipod;

@end
