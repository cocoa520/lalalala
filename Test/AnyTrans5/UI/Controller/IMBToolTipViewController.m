//
//  IMBToolTipViewController.m
//  iMobieTrans
//
//  Created by Pallas on 7/30/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBToolTipViewController.h"
#import "IMBToolTipView.h"
#import "StringHelper.h"
#import "NSColor+Category.h"

@implementation IMBToolTipViewController
@synthesize category = _category;
- (id)initWithToolTip:(NSString*)toolTipStr {
    self = [super initWithNibName:@"IMBToolTipViewController" bundle:nil];
    if (self) {
        _toolTipStr = [toolTipStr retain];
        [self.view setWantsLayer:YES];
    }
    return self;
}

- (void)dealloc {
    if (_toolTipStr != nil) {
        [_toolTipStr release];
        _toolTipStr = nil;
    }
    [super dealloc];
}

- (void)awakeFromNib {
    [self.view setWantsLayer:YES];
    [self.view.layer.superlayer setCornerRadius:7];
    [self.view.layer setCornerRadius:7];
    self.view.layer.backgroundColor = [NSColor clearColor].toCGColor;
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer.superlayer setMasksToBounds:YES];
     self.view.layer.superlayer.backgroundColor = [NSColor clearColor].toCGColor;

    if (_toolTipStr != nil) {
        NSSize size;
        NSMutableAttributedString *attrStr = [self measureForStringDrawing:_toolTipStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:11.0] withLineSpacing:2.f withMaxWidth:200.f withSize:&size];
        [tbToolTip setAllowsEditingTextAttributes:YES];
        [tbToolTip setAttributedStringValue:attrStr];
        [tbToolTip sizeToFit];
        if (size.width < 10) {
            size.width = 10;
        } else {
            size.width += 14;//10
        }
        if (size.height < 25) {
            size.height = 25;
        }
        size.height += 6;//2
        [self.view setFrameSize:size];
        int x = self.view.frame.origin.x + (self.view.frame.size.width - tbToolTip.frame.size.width) / 2;
        int y = self.view.frame.origin.y + 3 + (self.view.frame.size.height - tbToolTip.frame.size.height) / 2 +1;
        NSPoint newPos = NSMakePoint(x, y);
        [tbToolTip setFrameOrigin:newPos];
        if (tbToolTip.frame.size.height < 16) {
            [tbToolTip setFrameSize:NSMakeSize(tbToolTip.frame.size.width, 16)];
            [tbToolTip setFrameOrigin:NSMakePoint(tbToolTip.frame.origin.x, tbToolTip.frame.origin.y - 2)];
        }
    } else {
        NSSize defSize = NSMakeSize(10, 20);
        [tbToolTip setFrameSize:defSize];
        [self.view setFrameSize:tbToolTip.frame.size];
        int x = self.view.frame.origin.x + (self.view.frame.size.width - tbToolTip.frame.size.width) / 2;
        int y = self.view.frame.origin.y + (self.view.frame.size.height - tbToolTip.frame.size.height) / 2 ;
        NSPoint newPos = NSMakePoint(x, y);
        [tbToolTip setFrameOrigin:newPos];
        if (tbToolTip.frame.size.height < 16) {
            [tbToolTip setFrameSize:NSMakeSize(tbToolTip.frame.size.width, 16)];
            [tbToolTip setFrameOrigin:NSMakePoint(tbToolTip.frame.origin.x, tbToolTip.frame.origin.y - 2)];
        }
    }
}


- (NSMutableAttributedString*)measureForStringDrawing:(NSString*)myString withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withMaxWidth:(float)maxWidth withSize:(NSSize*)size {
    NSMutableAttributedString *retStr = [[NSMutableAttributedString alloc] initWithString:myString];

    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:lineSpacing];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *fontDic = nil;
    [textParagraph setAlignment:NSCenterTextAlignment];
    fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName, font,NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)],NSForegroundColorAttributeName,[NSColor clearColor],NSBackgroundColorAttributeName,nil];
    
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:lineSpacing];
    [retStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    NSSize tmpSize = [layoutManager usedRectForTextContainer:textContainer].size;
    (*size).width = ceil(tmpSize.width);
    (*size).height = ceil(tmpSize.height);
    return retStr;
}

- (void)setCategory:(NSString *)category {
    _category = category;
    if ([self.category isEqualToString: @"Category_iTunes_lib"]) {
        _toolTipView.isFirstCategory = YES;
    }else {
        _toolTipView.isFirstCategory = NO;
    }
}
@end
