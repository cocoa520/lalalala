//
//  iCloudDriveDownloadAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2018/1/31.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveDownloadOneAPI : BaseDriveAPI
{
    NSString *_iCloudDriveDocwsUrl; ///<文档url 主要用于下载和上传
    NSString *_documentID;    ///< icloud drive documentID
    NSString *_zone;          ///< iclouud drive所属zone
}

- (id)initWithDocumentID:(NSString *)documentID zone:(NSString *)zone iCloudDriveDocwsURL:(NSString *)url cookie:(NSMutableDictionary *)cookie;
@end
