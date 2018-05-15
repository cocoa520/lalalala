//
//  GooglePhotos.h
//  DriveSync
//
//  Created by 罗磊 on 2018/4/12.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDrive.h"

@interface GooglePhotos : BaseDrive

/**
 *  Description  根据用户名返回所有相册列表
 *
 *  @param accountName 用户名
 *  @param success     成功回调
 *  @param fail        失败回调
 */
- (void)getPhotoAlbumsList:(NSString *)accountName success:(Callback)success fail:(Callback)fail;

/**
 *  Description 根据用户名和相册id返回photo
 *
 *  @param accountName 用户名
 *  @param albumID     相册ID
 *  @param success     成功回调
 *  @param fail        失败回调
 */
- (void)getPhotoAlbumsPhotoList:(NSString *)accountName albumID:(NSString *)albumID success:(Callback)success fail:(Callback)fail;

@end
