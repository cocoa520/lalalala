//
//  IMBDatePicker.m
//  TestMyOwn
//
//  Created by iMobie on 7/1/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBDatePicker.h"
#import "NSBezierPath+BezierPathQuartzUtilities.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBDatePicker
@synthesize bindingEntity = _bindingEntity;
@synthesize bindingEntityKeyPath = _bindingEntityKeyPath;
@synthesize handleDelegate = _handleDelegate;
@synthesize isEmpty = _isEmpty;
@synthesize needHourMin = _needHourMin;
@synthesize noShadow = _noShadow;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc{
    if (_bindingEntity != nil) {
        [_bindingEntity release];
        _bindingEntity = nil;
    }
    if (_bindingEntityKeyPath != nil) {
        [_bindingEntityKeyPath release];
        _bindingEntityKeyPath = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

- (void)awakeFromNib{
    [self initialView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

-(void)mouseDown:(NSEvent *)event {
    if (!self.isEnabled) {
        return;
    }
    [super mouseDown:event];
    
    if(!_isEditing)
    {
        _isEditing = true;
        [self setNeedsDisplay:YES];
        //        NSRange range = NSMakeRange(0, self.stringValue.length);
        //        [self.cell selectWithFrame:[self bounds] inView:self editor:self.currentEditor delegate:self start:range.location length:range.length];
    }
    [[self window] makeFirstResponder:self];
}

- (void)initialView{
    [self setDatePickerMode:NSSingleDateMode];
    [self setDatePickerStyle:NSTextFieldDatePickerStyle];
    [self setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
    [self setMinDate:[NSDate dateWithString:@"0000-00-00 00:00:00 +0000"]];
    [self setMaxDate:[NSDate dateWithString:@"9999-00-00 00:00:00 +0000"]];
    [self setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [self setBordered:NO];
    [self setFrameSize:NSMakeSize(93, 17)];
    [self setDelegate:self];
    [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    if (![StringHelper stringIsNilOrEmpty:self.stringValue]) {
//        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:self.stringValue]autorelease];
//        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, attributedTitles.length)];
//        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, attributedTitles.length)];
//        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, attributedTitles.length)];
//        [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
//        [self setAttributedStringValue:attributedTitles];
//    }
}

- (void)setNeedHourMin:(BOOL)needHourMin
{
    _needHourMin = needHourMin;
    if (_needHourMin) {
        [self setDatePickerElements:NSYearMonthDayDatePickerElementFlag|NSHourMinuteDatePickerElementFlag];
        [self setFrameSize:NSMakeSize(155, 17)];
    }
}


- (void)viewDidMoveToSuperview{
    [super viewDidMoveToSuperview];
    [self initialView];
}

- (void)setBindingEntity:(id)bindingEntity{
    [_bindingEntity release];
    _bindingEntity = [bindingEntity retain];
    
    if ([bindingEntity isKindOfClass:[IMBContactKeyValueEntity class]]) {
        if (((IMBContactKeyValueEntity *)bindingEntity).value == nil) {
            _isEmpty = YES;
        }
        else{
            _isEmpty = NO;
        }
    }
}

- (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell validateProposedDateValue:(NSDate **)proposedDateValue timeInterval:(NSTimeInterval *)proposedTimeInterval{
    if (_bindingEntityKeyPath.length > 0 && _bindingEntity != nil) {
        if ([_bindingEntity isKindOfClass:[IMBContactKeyValueEntity class]]) {
//            NSLog(@"self.dateValue:%@",self.dateValue);
//            NSLog(@"self.dateValue:%@",*proposedDateValue);
            IMBContactKeyValueEntity *entity = _bindingEntity;
            [entity setValue:*proposedDateValue];
            BOOL isNowEmpty = false;
            if (isNowEmpty != _isEmpty) {
                _isEmpty = isNowEmpty;
                if ([_handleDelegate respondsToSelector:@selector(emptyFieldInItemViewHasEdit:)]) {
                    [_handleDelegate emptyFieldInItemViewHasEdit:self];
                }
            }

        }
        else if([_bindingEntity isKindOfClass:[IMBContactEntity class]]){
            IMBContactEntity *entity = _bindingEntity;
            [entity setBirthday:*proposedDateValue];
        }
    }
}

- (void)setDateValue:(NSDate *)newStartDate{
    [super setDateValue:newStartDate];
}

- (void)drawRect:(NSRect)dirtyRect
{
//        [[NSColor whiteColor] set];
//        NSRectFill(dirtyRect);
    NSPoint origin = { 0.0,0.0 };
    NSRect rect;
    rect.origin = origin;
    rect.size.width  = [self bounds].size.width;
    rect.size.height = [self bounds].size.height;
//        [[NSColor colorWithCalibratedWhite:1.0 alpha:0.394] set];
//        [path fill];
    if (_isEditing) {
//        [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] setStroke];
//        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
    }
    else{
//        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    }
    
    NSLog(@"firstResponder:%@",[[self window] firstResponder]);
    NSLog(@"appisActive:%@",[NSApp isActive]?@"isactive":@"isNotActive");
    if (([[self window] firstResponder] == self) && [NSApp isActive])
    {
//        NSBezierPath * path2;
//        path2 = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
//        [path2 fill];

        [super drawRect:dirtyRect];

        [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] setStroke];
        NSBezierPath * path1;
        path1 = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
        [path1 setLineWidth:1];
        [path1 stroke];
        [CATransaction setDisableActions:YES];
        if (_noShadow) {
            
        }else if (!isAddShapeLayer) {
            isAddShapeLayer = true;
            [self setWantsLayer:YES];
            if(_shapeLayer == nil){
                NSRect shadowRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width + 0.5 , rect.size.height + 3);
                NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRect:shadowRect];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                [shapeLayer setShadowColor:CGColorCreateGenericRGB(242/255, 242/255, 242/255, 0.4)];
                [shapeLayer setShadowOffset:CGSizeMake(0.5, 3)];
                [shapeLayer setShadowOpacity:1.0];
                [shapeLayer setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width + 0.5, rect.size.height + 3)];
                [shapeLayer setShadowPath:[shadowPath quartzPath]];
                _shapeLayer = [shapeLayer retain];
                
                [_shapeLayer setAutoreverses:YES];
                [_shapeLayer setAutoresizingMask:NSViewMaxXMargin
                 |NSViewMinYMargin];
                [_shapeLayer removeAllAnimations];
            }
            [self.superview setWantsLayer:YES];
            [_shapeLayer setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width + 0.5, rect.size.height + 3)];
            [self.superview.layer insertSublayer:_shapeLayer atIndex:0];
            [self.superview.layer removeAllAnimations];
        }
        else{
            NSRect shadowRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width + 0.5 , rect.size.height + 3);
            NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRect:shadowRect];
            [_shapeLayer setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width + 0.5, rect.size.height + 3)];
            [_shapeLayer setShadowPath:[shadowPath quartzPath]];
        }
        [CATransaction commit];
    }
    else
    {
        isAddShapeLayer = false;
        [_shapeLayer removeFromSuperlayer];
        NSRect newRect = rect;
        newRect.origin.x += 1;
        newRect.size.width -= 2;
        [super drawRect:dirtyRect];

    }
}

- (void)changeSkin:(NSNotification *)noti {
    [self setNeedsDisplay:YES];
    [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    if (![StringHelper stringIsNilOrEmpty:self.stringValue]) {
//        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:self.stringValue]autorelease];
//        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, attributedTitles.length)];
//        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, attributedTitles.length)];
//        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, attributedTitles.length)];
//        [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
//        [self setAttributedStringValue:attributedTitles];
//    }
}

@end
