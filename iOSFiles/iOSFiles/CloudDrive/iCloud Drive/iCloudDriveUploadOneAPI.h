//
//  iCloudDriveUploadOneAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2018/2/1.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveUploadOneAPI : BaseDriveAPI
{
    NSString *_iCloudDriveDocwsUrl; ///<文档url 主要用于下载和上传
    NSString *_mimeType;  //文件类型
}

- (id)initWithiCloudDriveDocwsUrl:(NSString *)url fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileSize:(long long)fileSize cookie:(NSMutableDictionary *)cookie;
@end
