//
//  GoogleDriveUploadAPITwo.h
//  DriveSync
//
//  Created by 罗磊 on 2018/1/9.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface GoogleDriveUploadAPITwo : BaseDriveAPI
{
    NSString *_uploadURLStr;
}

- (id)initWithUploadURLStr:(NSString *)uploadURLStr;

@end
