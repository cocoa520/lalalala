//
//  IMBReminderEditView.h
//  AnyTrans
//
//  Created by m on 17/2/9.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBMyDrawCommonly.h"
typedef void(^ReminderSaveBlock) (IMBMyDrawCommonly *button);
@interface IMBReminderEditView : NSView
{
    ReminderSaveBlock _saveBlock;
}
@property (nonatomic, copy)ReminderSaveBlock saveBlock;
@end
