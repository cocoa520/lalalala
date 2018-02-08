//
//  IMBVoiceMailSqliteManager.h
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBSqliteManager.h"
#import "IMBContactBaseInfoManager.h"
#import "IMBVoiceMailEntity.h"
@interface IMBVoiceMailSqliteManager : IMBSqliteManager
{
    IMBContactBaseInfoManager *_contactManager;
    NSString *_backupPath;
}
- (void)querySqliteDBContentBackupPath:(NSString *)backupPath;
@end
