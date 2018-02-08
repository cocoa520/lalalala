//
//  IMBCalendarContentView.m
//  iMobieTrans
//
//  Created by iMobie on 14-6-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBCalendarContentView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"

#define YNUMBER 8
@implementation IMBCalendarContentView
@synthesize description = _description;
@synthesize enddate = _enddate;
@synthesize startdate = _startdate;
@synthesize location = _location;
@synthesize title = _title;
@synthesize url = _url;
@synthesize editBlock = _editBlock;
@synthesize hasEditBtn = _hasEditBtn;
- (void) awakeFormNib {
    [super awakeFromNib];

}

- (id)initWithFrame:(NSRect)frame WithCategory:(CategoryNodesEnum)category
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
        _category = category;
        //TODO:calendar编辑先取消
        _editButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(self.frame.size.width - 100 ,16, 80, 22)];
        //设置按钮样式
        [_editButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        //线的颜色
        [_editButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
        [_editButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
        [_editButton setTitleName:CustomLocalizedString(@"Calendar_id_10", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [_editButton setTarget:self];
        [_editButton setAction:@selector(editing)];
        [_editButton setAutoresizingMask:NSViewMinXMargin|NSViewMaxYMargin];

    }
    return self;
}

- (void)setHasEditBtn:(BOOL)hasEditBtn {
    if (hasEditBtn) {
        [self addSubview:_editButton];
        [_editButton release];
    }else {
        if ([_editButton superview]) {
            [_editButton removeFromSuperview];
        }
    }
}

- (void)editing
{
    if (_editBlock != nil) {
        _editBlock();
    }
}

- (void)changeLanguage:(NSNotification *)notification {
    
    [_editButton setTitleName:CustomLocalizedString(@"Calendar_id_10", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_editButton setNeedsDisplay:YES];

    if (_category == Category_Calendar) {
        locationLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"Calendar_id_5", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        fromLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"icloud_reminder_11", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        toLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"icloud_reminder_12", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        urlLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"Bookmark_id_2", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        notesLabel = [[NSAttributedString alloc] initWithString:[[CustomLocalizedString(@"Calendar_id_11", nil) stringByReplacingOccurrencesOfString:@":" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    } else if (_category == Category_Reminder) {
        fromLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"icloud_reminder_11", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        toLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"icloud_reminder_12", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        notesLabel = [[NSAttributedString alloc] initWithString:[[CustomLocalizedString(@"Calendar_id_11", nil) stringByReplacingOccurrencesOfString:@":" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [self cacuLabelLength];
    if (_category == Category_Reminder) {
        
        if (_title != nil) {
            [self drawReminderTitle];
        }
        
        if (_startdate != nil) {
            [self drawReminderTime];
        }
        if (_description != nil) {
            [self drawReminderDescription];
        }
    }else {
        if (_title != nil) {
            [self drawTitile];
        }
        if (_location != nil) {
            
            [self drawLocation];
        }
        
        if (_startdate != nil) {
            [self drawTime];
        }
        if (_url != nil) {
            
            [self drawURL];
        }
        
        if (_description != nil) {
            [self drawDescription];
        }
    }
	[self resizeRect];
    
}

- (void)cacuLabelLength
{
    if (_category == Category_Calendar) {
        locationLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"Calendar_id_5", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        fromLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"icloud_reminder_11", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        toLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"icloud_reminder_12", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        urlLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"Bookmark_id_2", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        notesLabel = [[NSAttributedString alloc] initWithString:[[CustomLocalizedString(@"Calendar_id_11", nil) stringByReplacingOccurrencesOfString:@":" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        float max = 0;
        max = MAX(locationLabel.size.width, fromLabel.size.width);
        max = MAX(max, toLabel.size.width);
        max = MAX(max, urlLabel.size.width);
        max = MAX(max, notesLabel.size.width);
        longest = max;
    } else if (_category == Category_Reminder) {
        
        fromLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"icloud_reminder_11", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        toLabel = [[NSAttributedString alloc] initWithString:[CustomLocalizedString(@"icloud_reminder_12", nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        notesLabel = [[NSAttributedString alloc] initWithString:[[CustomLocalizedString(@"Calendar_id_11", nil) stringByReplacingOccurrencesOfString:@":" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        float max = 0;
        max = MAX(toLabel.size.width, fromLabel.size.width);
        max = MAX(max, notesLabel.size.width);
        longest = max;
    }
    
}

- (void)resizeRect{
    if(_title == nil){
        _title = [[NSString alloc] initWithString:@""];
    }
    if (_location == nil) {
        _location = [[NSString alloc] initWithString:@""];
    }
    if (_startdate == nil) {
        _startdate = [[NSString alloc] initWithString:@""];
    }
    if (_enddate == nil) {
        _enddate = [[NSString alloc] initWithString:CustomLocalizedString(@"iCloud_NoDate", nil)];
    }
    if (_url == nil) {
        _url = [[NSString alloc] initWithString:@""];
    }
    if (_description == nil) {
        _description = [[NSString alloc] initWithString:@""];
    }
    
   if (_descriptionRect.origin.y + _descriptionRect.size.height>532) {
        [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,_descriptionRect.origin.y + _descriptionRect.size.height)];
        
    }else
    {
        [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, 532-5)];
    }
    
    [self setNeedsDisplay:YES];
   
}


- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = [title retain];
        [self resizeRect];
       
    }
}

- (void)setLocation:(NSString *)location
{
    if (_location != location) {
        _location = [location retain];
        [self resizeRect];
    }
}

- (void)setEnddate:(NSString *)enddate
{
    if (_enddate != enddate) {
        _enddate = [enddate retain];
        [self resizeRect];
    }

}

- (void)setStartdate:(NSString *)startdate
{
    if (_startdate != startdate) {
        _startdate = [startdate retain];
        [self resizeRect];
    }


}

- (void)setDescription:(NSString *)description
{
    if (_description != description) {
        _description = [description retain];
        [self resizeRect];
    }

}
- (void)setUrl:(NSString *)url
{

    if (_url != url) {
        _url = [url retain];
        [self resizeRect];
    }

}
- (void)drawTitile
{
    NSRect titleRect = NSMakeRect(32, 68, self.frame.size.width - 200, 0);
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:[_title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:18.f];//[NSFont boldSystemFontOfSize:16.0f];
    
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:2.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    CGFloat height = [self heightForStringDrawing:_title fontSize:18 myWidth:titleRect.size.width];
    NSRect f = NSMakeRect(titleRect.origin.x , titleRect.origin.y, titleRect.size.width, height);
    [as.string drawInRect:f withAttributes:attributes];
    _titleRect = f;
    [as release];


}

- (void)drawReminderTitle {
    
    NSRect titleRect = NSMakeRect(32, 68, self.frame.size.width - 200, 0);
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:[_title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:18.f];//[NSFont boldSystemFontOfSize:16.0f];
    
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:2.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    CGFloat height = [self heightForStringDrawing:_title fontSize:18 myWidth:titleRect.size.width];
    NSRect f = NSMakeRect(titleRect.origin.x , titleRect.origin.y, titleRect.size.width, height);
    [as.string drawInRect:f withAttributes:attributes];
    _titleRect = f;
    [as release];
    
}

- (void)drawLocation
{
   
    NSRect homeRect = NSMakeRect(32, _titleRect.origin.y + _titleRect.size.height + 14,longest+10, 20);
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:2.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    [locationLabel.string drawInRect:homeRect withAttributes:attributes];
    //绘制Location
    NSRect locationRect = NSMakeRect(32, homeRect.origin.y + homeRect.size.height + 5, self.frame.size.width - 100, 0);
    NSAttributedString *as1 = [[NSAttributedString alloc] initWithString:[_location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:12];//[NSFont boldSystemFontOfSize:12];
    NSMutableParagraphStyle *paragraphStyle1 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle1 setAlignment:NSLeftTextAlignment];
    [paragraphStyle1 setLineSpacing:2.0f];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont1, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle1, NSParagraphStyleAttributeName,
                                nil];
    CGFloat height = [self heightForStringDrawing:_location fontSize:12 myWidth:locationRect.size.width];
    NSRect f = NSMakeRect(locationRect.origin.x , locationRect.origin.y, locationRect.size.width, height);
    [as1.string drawInRect:f withAttributes:attributes1];
    _locationRect = f;
    [locationLabel release];
    [as1 release];
}

- (void)drawTime
{
   //画线
   
    [self drawReminderline:NSMakePoint(32, _locationRect.origin.y + _locationRect.size.height + 5 - YNUMBER)];
    //绘制startDateLable:
    NSRect startDateRect = NSMakeRect(32, _locationRect.origin.y + _locationRect.size.height + 3 + 12 ,longest+10, 20);
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:2.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    [fromLabel.string drawInRect:startDateRect withAttributes:attributes];
    
    
    //绘制startdate
    NSRect startRect = NSMakeRect(32, startDateRect.origin.y + startDateRect.size.height + 3 ,300, 20);
    NSAttributedString *as1 = [[NSAttributedString alloc] initWithString:[_startdate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle1 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle1 setAlignment:NSLeftTextAlignment];
    [paragraphStyle1 setLineSpacing:2.0f];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont1, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle1, NSParagraphStyleAttributeName,
                                 nil];
    [as1.string drawInRect:startRect withAttributes:attributes1];
    
    //画线
    [self drawReminderline:NSMakePoint(32, startRect.origin.y + startRect.size.height + 11 - YNUMBER)];
    
    //绘制endDateLable:
    
    NSRect endDateRect = NSMakeRect(32, startRect.origin.y + startRect.size.height + 23,longest+10, 20);
    
    
    NSFont *sysFont2 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle2 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle2 setAlignment:NSLeftTextAlignment];
    [paragraphStyle2 setLineSpacing:2.0f];
    [paragraphStyle2 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont2, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle2, NSParagraphStyleAttributeName,
                                 nil];
    [toLabel.string drawInRect:endDateRect withAttributes:attributes2];
    
    //绘制enddate
    NSRect endRect = NSMakeRect(32, endDateRect.origin.y + endDateRect.size.height,300, 20);
    NSAttributedString *as3 = [[NSAttributedString alloc] initWithString:[_enddate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont3 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle3 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle3 setAlignment:NSLeftTextAlignment];
    [paragraphStyle3 setLineSpacing:2.0f];
    [paragraphStyle3 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont3, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle3, NSParagraphStyleAttributeName,
                                 nil];
    [as3.string drawInRect:endRect withAttributes:attributes3];
    //画线
    
    [self drawReminderline:NSMakePoint(32, endRect.origin.y + endRect.size.height + 12 - YNUMBER)];
    _timeRect = startRect;
    [fromLabel release];
    [toLabel release];
    [as1 release];
    [as3 release];

}

- (void)drawReminderTime {

    //绘制startDateLable:
    NSRect startDateRect = NSMakeRect(32, _titleRect.origin.y + _titleRect.size.height + 14 - 8,longest+10, 20);
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:2.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    [fromLabel.string drawInRect:startDateRect withAttributes:attributes];
    
    
    //绘制startdate
    NSRect startRect = NSMakeRect(32, startDateRect.origin.y + startDateRect.size.height + 5,300, 20);
    NSAttributedString *as1 = [[NSAttributedString alloc] initWithString:[_startdate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle1 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle1 setAlignment:NSLeftTextAlignment];
    [paragraphStyle1 setLineSpacing:2.0f];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont1, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle1, NSParagraphStyleAttributeName,
                                 nil];
    [as1.string drawInRect:startRect withAttributes:attributes1];
    
    //画线
    [self drawReminderline:NSMakePoint(32, startRect.origin.y + startRect.size.height + 11 - YNUMBER)];
    
    //绘制endDateLable:
    
    NSRect endDateRect = NSMakeRect(32, startRect.origin.y + startRect.size.height + 29,longest+10, 20);

    NSFont *sysFont2 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle2 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle2 setAlignment:NSLeftTextAlignment];
    [paragraphStyle2 setLineSpacing:2.0f];
    [paragraphStyle2 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont2, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle2, NSParagraphStyleAttributeName,
                                 nil];
    [toLabel.string drawInRect:endDateRect withAttributes:attributes2];
    
    //绘制enddate
    NSRect endRect = NSMakeRect(32, endDateRect.origin.y + endDateRect.size.height,300, 20);
    NSAttributedString *as3 = [[NSAttributedString alloc] initWithString:[_enddate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont3 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle3 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle3 setAlignment:NSLeftTextAlignment];
    [paragraphStyle3 setLineSpacing:2.0f];
    [paragraphStyle3 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont3, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle3, NSParagraphStyleAttributeName,
                                 nil];
    [as3.string drawInRect:endRect withAttributes:attributes3];
    //画线
    
    [self drawReminderline:NSMakePoint(32, endRect.origin.y + endRect.size.height + 12 - YNUMBER)];
    _timeRect = startRect;
    [fromLabel release];
    [toLabel release];
    [as1 release];
    [as3 release];
}

- (void)drawURL
{
   
    NSRect URLRect = NSMakeRect(32, _timeRect.origin.y + _timeRect.size.height + 88,longest+10, 20);
   
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:2.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    [urlLabel.string drawInRect:URLRect withAttributes:attributes];
    
    //绘制url
    NSRect urlRect = NSMakeRect(32, URLRect.origin.y + URLRect.size.height , self.frame.size.width - 100, 0);
    NSAttributedString *as1 = [[NSAttributedString alloc] initWithString:[_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle1 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle1 setAlignment:NSLeftTextAlignment];
    [paragraphStyle1 setLineSpacing:2.0f];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont1, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle1, NSParagraphStyleAttributeName,
                                 nil];
    CGFloat height = [self heightForStringDrawing:_url fontSize:14 myWidth:urlRect.size.width];
    NSRect f = NSMakeRect(urlRect.origin.x , urlRect.origin.y, urlRect.size.width, height);
    [as1.string drawInRect:f withAttributes:attributes1];
    _urlRect = f;
    //画线
    
    [self drawReminderline:NSMakePoint(32, _urlRect.origin.y + _urlRect.size.height + 3 - YNUMBER)];
    [as1 release];
    [urlLabel release];



}

- (void)drawDescription
{
    //绘制"Notes":
   
    NSRect URLRect = NSMakeRect(32, _urlRect.origin.y + _urlRect.size.height + 14,longest+10, 20);
  
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:2.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    [notesLabel.string drawInRect:URLRect withAttributes:attributes];
    
    //绘制description
    NSRect urlRect = NSMakeRect(32, URLRect.origin.y + URLRect.size.height + 3, self.frame.size.width - 100, 0);
    NSAttributedString *as1 = [[NSAttributedString alloc] initWithString:[_description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle1 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle1 setAlignment:NSLeftTextAlignment];
    [paragraphStyle1 setLineSpacing:2.0f];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont1, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle1, NSParagraphStyleAttributeName,
                                 nil];
    CGFloat height = [self heightForStringDrawing:_description fontSize:12 myWidth:urlRect.size.width];
    NSRect f = NSMakeRect(urlRect.origin.x , urlRect.origin.y, urlRect.size.width, height);
    [as1.string drawInRect:f withAttributes:attributes1];
    _descriptionRect = f;
    //画线
    
    [self drawReminderline:NSMakePoint(32, _descriptionRect.origin.y + height + 6 - YNUMBER)];
     [self setNeedsDisplay:YES];
    [as1 release];
    [notesLabel release];


}

- (void)drawReminderDescription {
    //绘制NotesLable:
    
    NSRect notesRect = NSMakeRect(32, _timeRect.origin.y + _timeRect.size.height + 93,longest+10, 20);
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:2.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                sysFont, NSFontAttributeName,
                                [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                nil];
    [notesLabel.string drawInRect:notesRect withAttributes:attributes];
    
    //绘制description
    NSRect descriptionRect = NSMakeRect(32, notesRect.origin.y + notesRect.size.height + 4, self.frame.size.width - 130, 0);
    NSAttributedString *as1 = [[NSAttributedString alloc] initWithString:[_description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    NSMutableParagraphStyle *paragraphStyle1 = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle1 setAlignment:NSLeftTextAlignment];
    [paragraphStyle1 setLineSpacing:2.0f];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 sysFont1, NSFontAttributeName,
                                 [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                 paragraphStyle1, NSParagraphStyleAttributeName,
                                 nil];
    CGFloat height = [self heightForStringDrawing:_description fontSize:14 myWidth:descriptionRect.size.width];
    NSRect f = NSMakeRect(descriptionRect.origin.x , descriptionRect.origin.y, descriptionRect.size.width, height);
    [as1.string drawInRect:f withAttributes:attributes1];
    _descriptionRect = f;
    //画线
    
    [self drawReminderline:NSMakePoint(32, _descriptionRect.origin.y + height + 6 - YNUMBER)];
    [self setNeedsDisplay:YES];
    [as1 release];
    [notesLabel release];
}

- (void)drawline:(NSPoint)point
{
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSMakeRect(point.x, point.y, self.frame.size.width - 40, 1)];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setFill];
    [path fill];

    
}

- (void)drawReminderline:(NSPoint)point {
    NSBezierPath *path;
    if (_category == Category_Calendar) {
          path = [NSBezierPath bezierPathWithRect:NSMakeRect(point.x, point.y, self.frame.size.width - 47, 1)];
    }else {
        path = [NSBezierPath bezierPathWithRect:NSMakeRect(point.x, point.y, self.frame.size.width - 47, 1)];
    }

    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setFill];
    [path fill];
}

- (BOOL)isFlipped
{
    return YES;
}

//计算高度
- (float)heightForStringDrawing:(NSString *)myString fontSize:(float)fontSize myWidth:(float) myWidth {
    
//    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
//    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)] autorelease];
//    
//    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
//    [layoutManager addTextContainer:textContainer];
//    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:2.0f];
    [textParagraph setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:fontSize],NSFontAttributeName,nil];
//    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
//    [textContainer setLineFragmentPadding:0.0];
//    (void) [layoutManager glyphRangeForTextContainer:textContainer];
     NSRect rect = [myString boundingRectWithSize:NSMakeSize(myWidth, 80000) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
    return rect.size.height+5;;
}

- (void)changeSkin:(NSNotification *)notification
{
    //设置按钮样式
    [_editButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [_editButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_editButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [_editButton setTitleName:CustomLocalizedString(@"Calendar_id_10", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_editButton setNeedsDisplay:YES];
    [self setNeedsDisplay:YES];
}

-(void)dealloc
{
    [_title release],_title = nil;
    [_location release],_location = nil;
    [_startdate release],_startdate = nil;
    [_enddate release],_enddate = nil;
    [_url release],_url = nil;
    [_description release],_description = nil;
    Block_release(_editBlock);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

@end
