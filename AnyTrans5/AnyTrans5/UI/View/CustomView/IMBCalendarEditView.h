//
//  IMBCalendarEditView.h
//  iMobieTrans
//
//  Created by iMobie on 14-9-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBMyDrawCommonly.h"
#import "IMBDatePicker.h"
typedef void(^CalendarSaveBlock) (IMBMyDrawCommonly *button);
@interface IMBCalendarEditView : NSView
{
    CalendarSaveBlock _saveBlock;
}
@property(nonatomic,copy)CalendarSaveBlock saveBlock;

@end
