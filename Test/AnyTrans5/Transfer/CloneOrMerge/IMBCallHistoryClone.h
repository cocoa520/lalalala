//
//  IMBCallHistoryClone.h
//  iMobieTrans
//
//  Created by iMobie on 14-12-17.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseClone.h"

@interface IMBCallHistoryClone : IMBBaseClone
{
    FMDatabase *_targetContactDBConnection;
    IMBMBFileRecord *_contactRecord;
    NSString *_contactsqlitePath;
}
- (void)merge:(NSMutableArray *)callHistory;
@end
