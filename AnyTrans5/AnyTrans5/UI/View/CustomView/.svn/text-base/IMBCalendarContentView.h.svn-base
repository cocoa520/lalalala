//
//  IMBCalendarContentView.h
//  iMobieTrans
//
//  Created by iMobie on 14-6-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBMyDrawCommonly.h"
typedef void(^CalendarEditBlock) (void);
@interface IMBCalendarContentView : NSView
{
    NSString    *_description;         //事件描述
    NSString    *_enddate;             //事件结束时间
    NSString    *_startdate;           //事件开始时间
    NSString    *_location;            //事件的地点
    NSString    *_title;               //事件的概述 就是标题
    NSString    *_url;                 //url
    NSRect _titleRect;
    NSRect _locationRect;
    NSRect _timeRect;
    NSRect _urlRect;
    NSRect _descriptionRect;
    
    NSAttributedString    *locationLabel;
    NSAttributedString    *fromLabel;
    NSAttributedString    *toLabel;
    NSAttributedString    *urlLabel;
    NSAttributedString    *notesLabel;
    
    int longest;
    CalendarEditBlock _editBlock;
    BOOL _hasEditBtn;
    IMBMyDrawCommonly *_editButton;
    CategoryNodesEnum _category;
    
}

@property(nonatomic,retain)IMBMyDrawCommonly *editButton;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *enddate;
@property(nonatomic,retain)NSString *startdate;
@property(nonatomic,retain)NSString *location;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,copy)CalendarEditBlock editBlock;
@property (nonatomic, assign) BOOL hasEditBtn;
- (id)initWithFrame:(NSRect)frame WithCategory:(CategoryNodesEnum)category;

@end
