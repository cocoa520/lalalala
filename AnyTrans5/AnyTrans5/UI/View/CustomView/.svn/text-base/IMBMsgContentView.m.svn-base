//
//  IMBMsgContentView.m
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBMsgContentView.h"
#import "IMBMsgDialog.h"
#import "IMBSMSChatDataEntity.h"
#import "IMBSMSChatDataEntity.h"
//#import "IMBHelper.h"
#import "StringHelper.h"
#import "IMBHeaderImageView.h"
#import "IMBAMDeviceInfo.h"
#import "IMBDeviceInfo.h"
#import "DateHelper.h"
@implementation IMBMsgContentView
@synthesize msgArray = _msgArray;
@synthesize smsEntity = _smsEntity;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self resizeRect];
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        [self resizeRect];
    }
    return self;
}

- (void)setFrame:(NSRect)frameRect{
    
    [super setFrame:frameRect];
    [self resizeRect];
}

- (void)dealloc{
    if (_msgViewArray != nil) {
        [_msgViewArray release];
        _msgViewArray = nil;
    }
    if (_msgArray != nil) {
        [_msgArray release];
        _msgArray = nil;
    }
    if (_smsEntity != nil) {
        [_smsEntity release];
        _smsEntity = nil;
    }
    [super dealloc];
}

- (BOOL)isFlipped{
    return YES;
}

- (void)resizeRect{
    NSRect rect = self.frame;
    if (rect.size.width < 460) {
        rect.size.width = 460;
        [self setFrame:rect];
    }
}

- (void)setMsgArray:(NSArray *)msgArray{
    if (_msgArray != nil) {
        [_msgArray release];
        _msgArray = nil;
    }
    _msgArray = [msgArray retain];
    [self buildSubViews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reload];
    });
    
}

- (void)setSmsEntity:(IMBSMSChatDataEntity *)smsEntity {
    if (_smsEntity != nil) {
        [_smsEntity release];
        _smsEntity = nil;
    }
    _smsEntity = [smsEntity retain];
    [self addHandleServcie];
}

- (void)addHandleServcie {
    if (_smsEntity != nil) {
        if (![StringHelper stringIsNilOrEmpty:_smsEntity.handleService]) {
            NSTextField *homeText = [[NSTextField alloc] init];
            [homeText setBordered:NO];
            [homeText setAlignment:NSLeftTextAlignment];
            [homeText setDrawsBackground:NO];
            [homeText setStringValue:[NSString stringWithFormat:@"<%@>",_smsEntity.handleService]];
            [homeText setTextColor:[NSColor colorWithDeviceRed:0.f/255 green:0.f/255 blue:0.f/255 alpha:1.0]];
            [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
            [homeText setFrame:NSMakeRect(0, 20, self.frame.size.width, 18)];
            [homeText setAlignment:NSCenterTextAlignment];
            [homeText setEditable:NO];
            [homeText setAutoresizingMask: NSViewWidthSizable];
            [self addSubview:homeText];
            [homeText release];
        }
    }
}

- (void)buildSubViews{
    dispatch_sync(dispatch_get_main_queue(), ^{
         [self resizeRect];
    });
   
    NSString *saveDateString = @"";
    if (_msgViewArray != nil) {
        [_msgViewArray release];
        _msgViewArray = nil;
    }
    _msgViewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _msgArray.count; i++) {
        @autoreleasepool {
            IMBMessageDataEntity *msgData = [_msgArray objectAtIndex:i];
            if (i == 0) {
                NSDate *date = [DateHelper getDateTimeFromTimeStamp2001:(uint)msgData.msgDate];
                NSString *dateString = [DateHelper getShortDateString:date];
                saveDateString = dateString;
                if (![StringHelper stringIsNilOrEmpty:dateString]) {
                    NSTextField *homeText = [[NSTextField alloc] init];
                    [homeText setBordered:NO];
                    [homeText setAlignment:NSLeftTextAlignment];
                    [homeText setDrawsBackground:NO];
                    [homeText setStringValue:dateString];
                    [homeText setTextColor:[NSColor colorWithDeviceRed:0.f/255 green:0.f/255 blue:0.f/255 alpha:1.0]];
                    [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
                    [homeText setFrame:NSMakeRect(0, 58, self.frame.size.width, 18)];
                    [homeText setAlignment:NSCenterTextAlignment];
                    [homeText setEditable:NO];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [homeText setAutoresizingMask: NSViewWidthSizable];
                        [self addSubview:homeText];
                    });
                    
                    [homeText release];
                }
                
                
                
   
                NSString *nameStr = msgData.contactName;
                if (![StringHelper stringIsNilOrEmpty:nameStr]&&![msgData.contactName isEqualToString:CustomLocalizedString(@"Common_id_4", nil)]) {
                    NSTextField *homeText = [[NSTextField alloc] init];
                    [homeText setBordered:NO];
                    [homeText setAlignment:NSLeftTextAlignment];
                    [homeText setDrawsBackground:NO];
                    [homeText setStringValue:nameStr];
                    [homeText setTextColor:[NSColor colorWithDeviceRed:0.f/255 green:0.f/255 blue:0.f/255 alpha:1.0]];
                    [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
                    [homeText setFrame:NSMakeRect(100, 70, self.frame.size.width, 22)];
                    [homeText setAlignment:NSLeftTextAlignment];
                    [homeText setEditable:NO];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [homeText setAutoresizingMask: NSViewWidthSizable];
                        [self addSubview:homeText];
                    });
                    
                    [homeText release];
                }
                
                
                IMBMsgDialog *dialog = [[IMBMsgDialog alloc] init];
                if ([_smsEntity.handleService isEqualToString:@"iMessage"]) {
                    dialog.isiMessage = YES;
                }else {
                    dialog.isiMessage = NO;
                }
                [dialog setMsgData:msgData];
                IMBHeaderImageView *headerImageView = nil;
                if (msgData.isSent) {
                    [dialog setFrame:NSMakeRect(self.frame.size.width - 80 - dialog.frame.size.width - 10, 96, dialog.frame.size.width, dialog.frame.size.height)];
                    //头像
                    headerImageView = [[IMBHeaderImageView alloc] initWithFrame:NSMakeRect(self.frame.size.width - 70, 96+dialog.frame.size.height-40, 40, 40)];
                    [dialog setAutoresizingMask: NSViewMinXMargin];
                    [headerImageView setAutoresizingMask:NSViewMinXMargin];
                    [headerImageView setHeaderimage:[StringHelper imageNamed:@"message_default"]];
                    [headerImageView setNeedsDisplay:YES];
                }else {
                    [dialog setFrame:NSMakeRect(80 +10, 96, dialog.frame.size.width, dialog.frame.size.height)];
                    //头像
                    headerImageView = [[IMBHeaderImageView alloc] initWithFrame:NSMakeRect(30,  96+dialog.frame.size.height-40, 40, 40)];
                    
                    [dialog setAutoresizingMask: NSViewMaxXMargin];
                    if (_smsEntity.headImage == nil) {
                        [headerImageView setHeaderimage:[StringHelper imageNamed:@"message_default"]];
                    }else{
                        [headerImageView setHeaderimage:_smsEntity.headImage];
                    }
                    [headerImageView setNeedsDisplay:YES];
                }
                
                
                
                if (self.frame.size.height < dialog.frame.origin.y + dialog.frame.size.height + 15) {
                    NSRect rect = self.frame;
                    rect.size.height = dialog.frame.origin.y + dialog.frame.size.height + 15;
                    [self setFrame:rect];
                }
                [_msgViewArray addObject:dialog];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self addSubview:dialog];
//                    [self addSubview:headerImageView];
                });
                
                [dialog release];
                [headerImageView release];
            }else {
                IMBMsgDialog *preDialog = [_msgViewArray objectAtIndex:(i-1)];
                
                float offest = 0;
                NSDate *date = [DateHelper getDateTimeFromTimeStamp2001:(uint)msgData.msgDate];
                NSString *dateString = [DateHelper getShortDateString:date];
                if (![saveDateString isEqualToString:dateString]) {
                    offest = 38;
                    saveDateString = dateString;
                    float h = preDialog.frame.origin.y + preDialog.frame.size.height + 20;
                    if (![StringHelper stringIsNilOrEmpty:dateString]) {
                        NSTextField *homeText = [[NSTextField alloc] init];
                        [homeText setBordered:NO];
                        [homeText setAlignment:NSLeftTextAlignment];
                        [homeText setDrawsBackground:NO];
                        [homeText setStringValue:dateString];
                        [homeText setTextColor:[NSColor colorWithDeviceRed:0.f/255 green:0.f/255 blue:0.f/255 alpha:1.0]];
                        [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
                        [homeText setFrame:NSMakeRect((self.frame.size.width - 400) / 2, h, 400, 18)];
                        [homeText setAlignment:NSCenterTextAlignment];
                        [homeText setEditable:NO];
                        [homeText setAutoresizingMask: NSViewWidthSizable];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                  
                            [self addSubview:homeText];
                        });
                        [homeText release];
                    }
                }
                if (![msgData.contactName isEqualToString:CustomLocalizedString(@"Common_id_4", nil)]) {
                    NSString *nameStr = msgData.contactName;
                    if (![saveDateString isEqualToString:nameStr]) {
                        offest = 38 + 18;
                        saveDateString = nameStr;
                        float h = preDialog.frame.origin.y + preDialog.frame.size.height + 20 + 18;
                        if (![StringHelper stringIsNilOrEmpty:nameStr]) {
                            NSTextField *homeText = [[NSTextField alloc] init];
                            [homeText setBordered:NO];
                            [homeText setAlignment:NSLeftTextAlignment];
                            [homeText setDrawsBackground:NO];
                            [homeText setStringValue:nameStr];
                            [homeText setTextColor:[NSColor colorWithDeviceRed:0.f/255 green:0.f/255 blue:0.f/255 alpha:1.0]];
                            [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
                            [homeText setFrame:NSMakeRect(96, h+6, 400, 22)];
                            [homeText setAlignment:NSLeftTextAlignment];
                            [homeText setEditable:NO];
                            [homeText setAutoresizingMask: NSViewWidthSizable];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                
                                [self addSubview:homeText];
                            });
                            [homeText release];
                        }
                    }
                }
                
                IMBMsgDialog *dialog = [[IMBMsgDialog alloc] init];
                if ([_smsEntity.handleService isEqualToString:@"iMessage"]) {
                    dialog.isiMessage = YES;
                }else {
                    dialog.isiMessage = NO;
                }
                [dialog setMsgData:msgData];
                float originY = preDialog.frame.origin.y + preDialog.frame.size.height + 15 + offest;
                if (msgData.isSent) {
                    [dialog setFrame:NSMakeRect(self.frame.size.width - 80 - dialog.frame.size.width, originY, dialog.frame.size.width, dialog.frame.size.height)];
                }else {
                    [dialog setFrame:NSMakeRect(80, originY, dialog.frame.size.width, dialog.frame.size.height)];
                }
                IMBHeaderImageView *headerImageView = nil;
                if (msgData.isSent) {
                    //头像
                    headerImageView = [[IMBHeaderImageView alloc] initWithFrame:NSMakeRect(self.frame.size.width - 70, originY+dialog.frame.size.height-40, 40, 40)];
                    [dialog setAutoresizingMask: NSViewMinXMargin];
                    [headerImageView setAutoresizingMask:NSViewMinXMargin];
                    [headerImageView setHeaderimage:[StringHelper imageNamed:@"message_default"]];
                    [headerImageView setNeedsDisplay:YES];
                }else
                {
                    //头像
                    headerImageView = [[IMBHeaderImageView alloc] initWithFrame:NSMakeRect(30, originY+dialog.frame.size.height-40, 40, 40)];
                         [dialog setAutoresizingMask: NSViewMaxXMargin];
                    if (_smsEntity.headImage == nil) {
                        [headerImageView setHeaderimage:[StringHelper imageNamed:@"message_default"]];
                    }else{
                        [headerImageView setHeaderimage:_smsEntity.headImage];
                    }
                    [headerImageView setNeedsDisplay:YES];
                }
                if (self.frame.size.height < dialog.frame.origin.y + dialog.frame.size.height + 15) {
                    NSRect rect = self.frame;
                    rect.size.height = dialog.frame.origin.y + dialog.frame.size.height + 15;
                    [self setFrame:rect];
                }
                [_msgViewArray addObject:dialog];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self addSubview:dialog];
//                    [self addSubview:headerImageView];
                });
                
                [headerImageView release];
                [dialog release];
            }
        }
    }
}

- (void)reload{
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}


@end
