//
//  IMBNoteClone.h
//  iMobieTrans
//
//  Created by iMobie on 14-12-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseClone.h"

@interface IMBNoteClone : IMBBaseClone
{
    BOOL _sourcedbType;
    BOOL _targetdbType;
    NSMutableArray *_attachmentIdentifierList;
    int _localaccountZPK;
    int _trashFolderZPK;
    int _defaultFolderZPK;
    int noteZENT;
    int attachZENT;
    int mediaZENT;
    int preViewZENT;
    int folderZENT;
    int acountZENT;
    int legacyZENT;
    int noteTargetZENT;
    int attachTargetZENT;
    int mediaTargetZENT;
    int preViewTargetZENT;
    int acountTargetZENT;
    int folderTargetZENT;
    int legacyTargetZENT;
}
- (void)merge:(NSArray *)noteArray;
@end
