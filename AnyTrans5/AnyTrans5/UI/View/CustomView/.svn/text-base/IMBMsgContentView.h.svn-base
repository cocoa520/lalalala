//
//  IMBMsgContentView.h
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "IMBSMSChatDataEntity.h"

@interface IMBMsgContentView : NSView
{
    //存放的是IMBMessageEntity
    NSArray *_msgArray;
    NSMutableArray *_msgViewArray;
    IMBSMSChatDataEntity *_smsEntity;

}

@property (nonatomic,retain,setter = setMsgArray:) NSArray *msgArray;
@property (nonatomic,retain,setter = setSmsEntity:) IMBSMSChatDataEntity *smsEntity;

- (void)setMsgArray:(NSArray *)msgArray;
- (void)setSmsEntity:(IMBSMSChatDataEntity *)smsEntity;

@end
