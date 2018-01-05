//
//  IMBNoteExport.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseTransfer.h"
@interface IMBNoteExport : IMBBaseTransfer {
    NSString *_attachmentsPath;
}

#pragma mark - export 附件方法
- (NSString *)exportSingleAttachmentsToLacol:(NSArray *)attachArray withPath:(NSString *)path;

@end
