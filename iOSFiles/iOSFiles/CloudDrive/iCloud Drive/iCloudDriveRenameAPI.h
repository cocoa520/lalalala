//
//  iCloudDriveRenameAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2018/1/31.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveRenameAPI : BaseDriveAPI
{
    /**
     *  itemDic 构建 eg:
     @{
     @"drivewsid": @"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
     @"etag": @"pi",
     @"name": @"hhh22"
     }
     
     */
    NSDictionary *_itemDic; ///< 重命名项字典
}

/**
 *  Description 重命名初始化方法
 *
 *  @param item  重命名项 eg   
 *        @{
 *        @"drivewsid": @"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *        @"etag": @"pi",
 *        @"name": @"hhh22"
 *        }
 *  @param dsid   dsid
 *  @param cookie cookies
 *  @param url    url
 *
 *  @return 自己
 */
- (id)initWithRenameItems:(NSDictionary *)item dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url;
@end
