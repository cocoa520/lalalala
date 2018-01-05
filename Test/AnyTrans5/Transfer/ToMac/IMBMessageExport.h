//
//  IMBMessageExport.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseTransfer.h"
#import "IMBSMSChatDataEntity.h"
#import "IMBExportSetting.h"
@interface IMBMessageExport : IMBBaseTransfer
{
    NSString *_attachmentsPath;
    IMBSMSChatDataEntity *_msgChat;
}

- (NSString *)exportSingleAttachmentsToLacol:(NSArray *)attachArray withPath:(NSString *)path;

@end
