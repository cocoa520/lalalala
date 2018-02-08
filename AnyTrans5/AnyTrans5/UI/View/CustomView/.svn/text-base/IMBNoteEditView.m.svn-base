//
//  IMBNoteEditView.m
//  iMobieTrans
//
//  Created by apple on 9/27/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBNoteEditView.h"
#import "StringHelper.h"

@implementation IMBNoteEditView
@synthesize time = _time;
@synthesize contentValue = _contentValue;
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

- (void)initialViews{
    _timeField = [[NSTextField alloc] initWithFrame:NSMakeRect(15, 20, 206, 22)];
    [_timeField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_timeField setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_timeField setDrawsBackground:NO];
    [_timeField setBordered:NO];
    [_timeField setEditable:NO];
    [_timeField setSelectable:NO];
    [_timeField setFocusRingType:NSFocusRingTypeNone];

    _contentField = [[NoteTextGrowthField alloc] initWithFrame:NSMakeRect(15, 53, self.frame.size.width - 27, 22)];
    [_contentField setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_contentField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_contentField setDrawsBackground:NO];
    [_contentField setBordered:NO];
    [_contentField setFocusRingType:NSFocusRingTypeNone];
    [[_contentField cell] setPlaceholderString:CustomLocalizedString(@"MenuItem_id_17", nil)];
//    [_contentField setAutoresizesSubviews:YES];
    [_contentField setAutoresizingMask:NSViewWidthSizable|NSViewMaxYMargin];
    [self setTexts];
    [self addSubview:_timeField];
    [self addSubview:_contentField];
}


- (void)viewDidMoveToSuperview{
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

}

- (void)awakeFromNib{
    [self setTexts];
}

- (void)setTexts{
    if(_time == nil){
        _time = [[NSString alloc] initWithString:@""];
    }
    if (_contentValue == nil) {
        _contentValue = [[NSString alloc] initWithString:@""];
    }
    [_timeField setStringValue:_time];
    [_contentField setStringValue:_contentValue];
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    [_contentField setCanBeEditing:isEditing];
}

- (void)setBindingEntity:(id)bindingEntiy andPath:(NSString *)bindingPath
{
    [_contentField setBindingEntity:bindingEntiy andPath:bindingPath];
}

- (BOOL)isFlipped{
    return YES;
}

- (void)dealloc{
    if (_time != nil) {
        [_time release];
        _time = nil;
    }
    
    if (_contentValue != nil) {
        [_contentValue release];
        _contentValue = nil;
    }
    
    if (_timeField != nil) {
        [_timeField release];
        _timeField = nil;
    }
    
    if (_contentField != nil) {
        [_contentField release];
        _contentField = nil;
    }
    [super dealloc];
}



- (void)setContent:(NSString *)content{
    [_contentValue release];
    _contentValue =[content retain];
    [_contentField setIsEditing:YES];
    [_contentField setStringValue:_contentValue];
    [_contentField becomeFirstResponder];
}

- (void)setTime:(NSString *)time{
    if (time.length == 0) {
        time = @"";
    }
    [_time release];
    _time = [time retain];
    [_timeField setStringValue:_time];
}


@end
