//
//  IMBFilpedView.h
//  DataRecovery
//
//  Created by iMobie on 5/31/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBSMSChatDataEntity.h"
@interface IMBFilpedView : NSView
{
    IMBSMSChatDataEntity *_smsData;
}
@property (nonatomic, retain) IMBSMSChatDataEntity *smsData;
@end
