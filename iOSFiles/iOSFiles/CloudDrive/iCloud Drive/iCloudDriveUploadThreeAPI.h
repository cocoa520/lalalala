//
//  iCloudDriveUploadThreeAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2018/2/2.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveUploadThreeAPI : BaseDriveAPI
{
    NSString *_iCloudDriveDocwsUrl; ///<文档url 主要用于下载和上传
    NSString *_documentID;    ///< icloud drive documentID 由第一步得来
    NSMutableDictionary *_dataDic;       ///< 由第二步得来
}

- (id)initWithiCloudDriveDocwsUrl:(NSString *)url dataDic:(NSMutableDictionary *)dataDic fileName:(NSString *)fileName parent:(NSString *)parent  documentID:(NSString *)documentID cookie:(NSMutableDictionary *)cookie;
@end
