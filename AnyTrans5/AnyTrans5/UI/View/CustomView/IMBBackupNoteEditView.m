//
//  IMBNoteEditView.m
//  iMobieTrans
//
//  Created by apple on 9/27/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBackupNoteEditView.h"
#import "TempHelper.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBBackupNoteEditView
@synthesize time = _time;
@synthesize contentValue = _contentValue;
@synthesize noteHigh = _noteHigh;
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

- (void)initialViews{
    _timeField = [[NSTextField alloc] initWithFrame:NSMakeRect(15, 20, 206, 22)];
    [_timeField setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
//    [_timeField setDrawsBackground:NO];
    [_timeField setBordered:NO];
    [_timeField setEditable:NO];
    [_timeField setSelectable:NO];
    [_timeField setDrawsBackground:NO];
    [_timeField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_timeField setFocusRingType:NSFocusRingTypeNone];

    _contentField = [[NoteTextGrowthField alloc] initWithFrame:NSMakeRect(15, 53, self.frame.size.width - 27, 22)];
    [_contentField setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_contentField setFontSize:14.0];
    [_contentField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_contentField setDrawsBackground:NO];
    [_contentField setBordered:NO];
    [_contentField setFocusRingType:NSFocusRingTypeNone];
    [[_contentField cell] setPlaceholderString:CustomLocalizedString(@"MenuItem_id_17", nil)];
    //    [_contentField setAutoresizesSubviews:YES];
    [_contentField setAutoresizingMask:NSViewWidthSizable|NSViewMaxYMargin];
//    [self setTexts];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

- (void)setContent:(NSString *)content{
    [_contentValue release];
    _contentValue = nil;
    _contentValue =[content retain];
    [_contentField setIsEditing:NO];
    [_contentField.cell setSelectable:NO];
    
    [_contentField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_contentField setStringValue:content];
    [_contentField setFrame:NSMakeRect(15,53, _contentField.frame.size.width, 500)];
//    NSSize size = [_contentField.cell cellSizeForBounds:_contentField.frame];
    float H = [self heightForStringDrawingWithWidth:_contentField.frame.size.width withString:content];
    if (H < 100) {
        H = 160;
    }else{
        H = H + 80;
    }
    [_contentField setFrameSize:NSMakeSize(_contentField.frame.size.width, H)];
    
    [self setFrameSize:NSMakeSize(self.frame.size.width, H + 53)];

}

- (float)heightForStringDrawingWithWidth:(float)myWidth withString:(NSString *)content {
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:content] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    NSDictionary *fontDic = [self attributes:14];
    NSRect rect = [content boundingRectWithSize:NSMakeSize(myWidth, 30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
    return rect.size.height+6;
}

- (NSDictionary *)attributes:(float)fontSize{
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:4.0];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:fontSize],NSFontAttributeName,nil];
    return fontDic;
}


- (void)setTime:(NSString *)time{
    if (time.length == 0) {
        time = @"";
    }
    [_time release];
    _time = [time retain];
    [_timeField setStringValue:_time];
}

- (void)addAttachment:(NSString *)path {
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    NSImage *showImage = nil;
    if (image.size.width > 460 || image.size.height > 460) {
        showImage = [[NSImage alloc] initWithData:[TempHelper scalingImage:image withLenght:460]];
    }else {
        showImage = [image retain];
    }
    
    if (image != nil) {
        [image release];
        image = nil;
    }
    if (showImage != nil) {
        float H = [self heightForStringDrawingWithWidth:_contentField.frame.size.width withString:_contentField.stringValue];
        _noteHigh += showImage.size.height+20;
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(20, H +_noteHigh - showImage.size.height+50, showImage.size.width, showImage.size.height)];
        [imageView setImage:showImage];
        [self setFrameSize:NSMakeSize(self.frame.size.width, H + _noteHigh+80)];
        [self addSubview:imageView];
        [imageView release];
        imageView = nil;
   
        [showImage release];
        showImage = nil;
    }
}

- (void)setCanBeEditing:(BOOL)canBeEditing{
    NSText *fieldEditor = [self.window fieldEditor:NO forObject:self];
    if([fieldEditor isKindOfClass:[NSTextView class]])
    {
        NSTextView *textView = (NSTextView *)fieldEditor;
        [textView setEditable:canBeEditing];
        [textView setSelectable:canBeEditing];
    }
}

- (void)setBindingEntity:(id)bindingEntiy andPath:(NSString *)bindingPath
{
    [_contentField setBindingEntity:bindingEntiy andPath:bindingPath];
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    [_contentField setCanBeEditing:isEditing];
}

@end
