//
//  IMBContactClone.h
//  iMobieTrans
//
//  Created by iMobie on 14-12-12.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBSqliteManager.h"
#import "IMBBaseClone.h"

@interface IMBContactClone : IMBBaseClone
{
    IMBMBFileRecord *_sourceContactImageRecord;
    IMBMBFileRecord *_targetContactImageRecord;
    NSString *_sourceSqliteContactImagePath;
    NSString *_targetSqliteContactImagePath;
    FMDatabase *_sourceImageDBConnection;
    FMDatabase *_targetImageDBConnection;
}
- (void)merge:(NSArray *)contactArray;
@end
