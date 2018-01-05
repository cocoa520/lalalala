//
//  IMBCalendarNoteEditView.m
//  AnyTrans
//
//  Created by smz on 17/8/3.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBCalendarNoteEditView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"

@implementation IMBCalendarNoteEditView
@synthesize contentField = _contentField;

- (id)init{
    if (self = [super init]) {
        [self initialViews];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        [self initialViews];
    }
    return self;
}

- (void)changeSkin:(NSNotification *)notification
{
    [self initialViews];
}

- (void)initialViews {
    
    _contentField = [[NoteTextGrowthField alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, 22)];
    [_contentField setFont:[NSFont fontWithName:@"Helvetica Neue" size:13.0]];
    [_contentField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_contentField setDrawsBackground:NO];
    [_contentField setBordered:NO];
    [_contentField setIsCalendarNote:YES];
    [_contentField setFontSize:13.0];
    [_contentField setFocusRingType:NSFocusRingTypeNone];
    [self addSubview:_contentField];
}


- (void)viewDidMoveToSuperview{
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    [_contentField setCanBeEditing:isEditing];
}

- (BOOL)isFlipped{
    return YES;
}

- (void)dealloc{
    if (_contentField != nil) {
        [_contentField release];
        _contentField = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

@end
