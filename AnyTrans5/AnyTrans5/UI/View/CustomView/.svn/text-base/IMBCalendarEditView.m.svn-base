//
//  IMBCalendarEditView.m
//  iMobieTrans
//
//  Created by iMobie on 14-9-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBCalendarEditView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBCalendarEditView
@synthesize saveBlock = _saveBlock;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    NSString *doneStr = CustomLocalizedString(@"contact_id_92", nil);
    NSRect doneRect = [StringHelper calcuTextBounds:doneStr fontSize:12];
    int w = 70;
    if (doneRect.size.width > 70) {
        w = doneRect.size.width + 10;
    }

    
    IMBMyDrawCommonly *saveButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(535,NSHeight(self.frame) - 22 -20, w, 22)];
    //设置按钮样式
    [saveButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [saveButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [saveButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [saveButton setTitleName:CustomLocalizedString(@"contact_id_92", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [saveButton setFrameOrigin:NSMakePoint(NSWidth(self.frame) - NSWidth(saveButton.frame) -25, NSMinY(saveButton.frame) + 7)];
    [saveButton setAutoresizesSubviews:YES];
    [saveButton setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin];
    [saveButton setTarget:self];
    saveButton.tag = 600;
    [saveButton setAction:@selector(saveCalendar:)];
    [self addSubview:saveButton];
    [saveButton release];
    
    
    NSString *cancelStr = CustomLocalizedString(@"Calendar_id_12", nil);
    NSRect cancelRect = [StringHelper calcuTextBounds:cancelStr fontSize:12];
    int cancelw = 70;
    if (cancelRect.size.width > 70) {
        cancelw = cancelRect.size.width + 10;
    }
    IMBMyDrawCommonly *quitButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(466,NSHeight(self.frame) - 22 -20, cancelw, 22)];
    [quitButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [quitButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [quitButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [quitButton setTitleName:CustomLocalizedString(@"Calendar_id_12", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [quitButton setFrameOrigin:NSMakePoint(NSWidth(self.frame) - NSWidth(saveButton.frame) - NSWidth(quitButton.frame)  -25 - 15, NSMinY(quitButton.frame) + 7)];
    [quitButton setAutoresizesSubviews:YES];
    [quitButton setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin];
    [quitButton setTarget:self];
    quitButton.tag = 601;
    [quitButton setAction:@selector(saveCalendar:)];
    [self addSubview:quitButton];
    [quitButton release];
   
}

- (void)saveCalendar:(id)sender
{
    if (_saveBlock != nil) {
        _saveBlock(sender);
    }
}

- (void)changeSkin:(NSNotification *) noti {
    IMBMyDrawCommonly *quitButton = [self viewWithTag:601];
    [quitButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [quitButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [quitButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [quitButton setNeedsDisplay:YES];
    
    IMBMyDrawCommonly *saveButton = [self viewWithTag:600];
    [saveButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [saveButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [saveButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [saveButton setNeedsDisplay:YES];
}

- (void)changeLanguage
{
    IMBMyDrawCommonly *saveButton = [self viewWithTag:600];
    IMBMyDrawCommonly *quitButton = [self viewWithTag:601];
    [saveButton setTitleName:CustomLocalizedString(@"contact_id_92", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [quitButton setTitleName:CustomLocalizedString(@"Calendar_id_12", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [saveButton setNeedsDisplay:YES];
    [quitButton setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    Block_release(_saveBlock);
    [super dealloc];
}
@end
