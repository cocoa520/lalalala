//
//  IMBReminderEditView.m
//  AnyTrans
//
//  Created by m on 17/2/9.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBReminderEditView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBReminderEditView
@synthesize saveBlock = _saveBlock;

- (void)awakeFromNib
{
    [self initDoneAndCancelButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)initDoneAndCancelButton{
    NSString *doneStr = CustomLocalizedString(@"contact_id_92", nil);
    NSRect doneRect = [StringHelper calcuTextBounds:doneStr fontSize:13];
    int w = 80;
    if (doneRect.size.width > 80) {
        w = doneRect.size.width + 10;
    }
    IMBMyDrawCommonly *doneButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(506 - w ,self.frame.size.height - 35 , w, 20)];
    doneButton.tag = 101;
    //设置按钮样式
    [doneButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [doneButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [doneButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [doneButton setTitleName:doneStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [doneButton setTarget:self];
    [doneButton setAction:@selector(saveReminder:)];
    
    NSString *doneStr1 = CustomLocalizedString(@"contact_id_92", nil);
    NSRect doneRect1 = [StringHelper calcuTextBounds:doneStr1 fontSize:13];
    int w1 = 80;
    if (doneRect1.size.width > 80) {
        w1 = doneRect1.size.width + 10;
    }
    
    NSString *cancelStr = CustomLocalizedString(@"Calendar_id_12", nil);
    NSRect cancelRect = [StringHelper calcuTextBounds:cancelStr fontSize:13];
    w = 80;
    if (cancelRect.size.width > 80) {
        w = cancelRect.size.width + 10;
    }
    IMBMyDrawCommonly *cancelButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(doneButton.frame.origin.x - 10 - w, doneButton.frame.origin.y, w, doneButton.frame.size.height)];
    cancelButton.tag = 102;
    //设置按钮样式
    [cancelButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [cancelButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [cancelButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [cancelButton setTitleName:cancelStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [cancelButton setTarget:self];
    [cancelButton setAction:@selector(saveReminder:)];
    
    [doneButton setAutoresizingMask:YES];
    [doneButton setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin];
    [cancelButton setAutoresizingMask:YES];
    [cancelButton setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin];
    [self addSubview:cancelButton];
    [self addSubview:doneButton];

}

- (void)saveReminder:(id)sender {
    if (_saveBlock != nil) {
        _saveBlock(sender);
    }
}


- (void)doChangeLanguage:(NSNotification *)noti {
    IMBMyDrawCommonly *doneBtn = [self viewWithTag:101];
    IMBMyDrawCommonly *cancelBtn = [self viewWithTag:102];
    NSString *doneStr = CustomLocalizedString(@"contact_id_92", nil);
    [doneBtn setTitleName:doneStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSString *cancelStr = CustomLocalizedString(@"Calendar_id_12", nil);
    [cancelBtn setTitleName:cancelStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [doneBtn setNeedsDisplay:YES];
    [cancelBtn setNeedsDisplay:YES];
}

- (void)changeSkin:(NSNotification *)noti {
    IMBMyDrawCommonly *doneButton = [self viewWithTag:101];
    IMBMyDrawCommonly *cancelButton = [self viewWithTag:102];
    [doneButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [doneButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [doneButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [doneButton setNeedsDisplay:YES];
    [cancelButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [cancelButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [cancelButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [cancelButton setNeedsDisplay:YES];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    Block_release(_saveBlock);
    [super dealloc];
}

@end
