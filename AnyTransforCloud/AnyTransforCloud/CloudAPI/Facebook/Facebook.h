//
//  Facebook.h
//  DriveSync
//
//  Created by JGehry on 26/02/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BaseDrive.h"

@interface Facebook : BaseDrive

/**
 *  获取相册及视频列表
 *
 *  @param folerID 默认传入"0"
 *  @param isVideo 是否为视频，如果为相册，传入NO；如果为视频，传入YES
 *  @param success 成功回调
 *  @param fail    失败回调
 */
- (void)getList:(NSString *)folerID isVideo:(BOOL)isVideo success:(Callback)success fail:(Callback)fail;

/**
 *  获取某个视频
 *
 *  @param videoID 传入视频ID
 *  @param success 成功回调
 *  @param fail    失败回调
 */
- (void)getVideo:(NSString *)videoID success:(Callback)success fail:(Callback)fail;

/**
 *  获取时间线帖子
 *
 *  @param folderID 默认传入"0"
 *  @param success  成功回调
 *  @param fail     失败回调
 */
- (void)getTimeline:(NSString *)folderID success:(Callback)success fail:(Callback)fail;

@end
