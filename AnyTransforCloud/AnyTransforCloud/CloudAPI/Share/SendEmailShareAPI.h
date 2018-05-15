//
//  SendEmailShareAPI.h
//  DriveSync
//
//  Created by JGehry on 2018/5/11.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface SendEmailShareAPI : BaseDriveAPI

@end

@interface NSString (SendEmailShareAPI)
- (NSString *)st_urlEncodedString;
@end


