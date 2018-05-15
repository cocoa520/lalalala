//
//  iCloudDriveCopyItemAPI.h
//  DriveSync
//
//  Created by JGehry on 2018/5/4.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveCopyItemAPI : BaseDriveAPI
{
    NSArray *_itemDics; ///< 重命名项字典
}

- (id)initWithCopyItemDic:(NSArray *)dics newParentIDOrPathdsid:(NSString *)parent dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url;

@end
