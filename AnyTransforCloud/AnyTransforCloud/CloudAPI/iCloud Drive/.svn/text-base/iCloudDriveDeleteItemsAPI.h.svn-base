//
//  iCloudDriveDeleteItems.h
//  DriveSync
//
//  Created by 罗磊 on 2018/1/31.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveDeleteItemsAPI : BaseDriveAPI
{
    NSArray *_deleteItmes;
}
/**
 *  Description 批量删除文件和文件夹
 *
 *  @param deleteItems 一个字典数组  字典为 
 *  eg: @{@"etag" : @"oz",@"drivewsid" : @"FOLDER::com.apple.CloudDocs::B661E364-426F-4EAF-A2FE-2BAB5BA7CA96"}
 *  @param dsid        icloud drive唯一标志id
 *  @param cookie      cookie
 *  @param url         基url
 *
 *  @return 返回自己
 */
- (id)initWithDeleteItems:(NSArray *)deleteItems dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url;
@end
