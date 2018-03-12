//
//  IMBDropBoxManage.h
//  iOSFiles
//
//  Created by JGehry on 3/12/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dropbox.h"
#import "IMBDriveBaseManage.h"
@interface IMBDropBoxManage : IMBDriveBaseManage<BaseDriveDelegate>
{
    Dropbox *_dropbox;
}


/**
 *  初始化
 *
 *  @param userID id
 *  @param parent 原父目录 视情况而定有的平台 不需要parent参数 传nil即可 比如onedrive 不需要parent参数
 *  @param idOrPath  自身的id或者路径
 *  @param success   成功回调block
 *  @param fail      失败回调block
 */
- (nullable id)initWithUserID:(nullable NSString *)userID withDelegate:(nullable id)delegate;

@end
