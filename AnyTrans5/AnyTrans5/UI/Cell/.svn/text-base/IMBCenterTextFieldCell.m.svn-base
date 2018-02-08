//
//  CenterTextFieidCell.m
//  AppDemo
//
//  Created by zhang yang on 13-3-6.
//  Copyright (c) 2013年 iMobie. All rights reserved.
//

#import "IMBCenterTextFieldCell.h"
#import "StringHelper.h"
#import "IMBWhiteView.h"
#import "IMBADAudioTrack.h"
#import "IMBADVideoTrack.h"
#import "IMBHelper.h"
#import "IMBADFileEntity.h"
@implementation IMBCenterTextFieldCell
@synthesize nodeDetail = _nodeDetail;
@synthesize mouseMoveNodeDetail = _mouseMoveNodeDetail;
@synthesize titleColor = _titleColor;
@synthesize fontSize = _fontSize;
@synthesize hilightTitleColor = _hilightTitleColor;
@synthesize isLoading = _isLoading;
@synthesize isLastCell = _isLastCell;
@synthesize isExist = _isExist;
@synthesize isRighVale = _isRighVale;
@synthesize isDeleted = _isDeleted;
@synthesize isExistAndDeleted = _isExistAndDeleted;
@synthesize isItem = _isItem;
@synthesize isExplainColor = _isExplainColor;
@synthesize entity = _entity;
@synthesize category = _category;
- (id)init
{
    if (self = [super init]) {
        [self initProperties];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initProperties];
}

- (void)initProperties
{
    _titleColor = [[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] retain];
    _hilightTitleColor = [[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] retain];
    _fontSize = 12.0f;
    _isLoading = NO;
    _isExist = YES;
}

- (void)dealloc
{
    [_titleColor release],_titleColor = nil;
    [_hilightTitleColor release], _hilightTitleColor = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    IMBCenterTextFieldCell *cell = (IMBCenterTextFieldCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_titleColor = [_titleColor retain];
    cell->_hilightTitleColor = [_hilightTitleColor retain];
    return cell;
}

-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    NSAttributedString *attrString = self.attributedStringValue;
    NSMutableAttributedString *titleStr = [attrString mutableCopy];
    if (_isLoading) {
        [titleStr release];
        titleStr = nil;
    }
    
    /* if your values can be attributed strings, make them white when selected */
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:self.lineBreakMode];
    if (_isRighVale) {
        [textParagraph setAlignment:NSRightTextAlignment];
    }else{
        [textParagraph setAlignment:self.alignment];
    }
    
    if (self.isHighlighted|| self.backgroundStyle == NSBackgroundStyleDark ) {
        if (self.isHighlighted && self.backgroundStyle == NSBackgroundStyleDark ) {
            [titleStr addAttribute: NSForegroundColorAttributeName
                             value: [StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]
                             range: NSMakeRange(0, titleStr.length) ];
            [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
        }else{
            [titleStr addAttribute: NSForegroundColorAttributeName
                             value: [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
                             range: NSMakeRange(0, titleStr.length) ];
            [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
        }
    }else {
        if (controlView == [[controlView window] firstResponder]) {
            if (_isExist) {
                [titleStr addAttribute: NSForegroundColorAttributeName
                                 value: [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
                                 range: NSMakeRange(0, titleStr.length) ];
                [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
            }else {
                [titleStr addAttribute: NSForegroundColorAttributeName
                                 value: [StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]
                                 range: NSMakeRange(0, titleStr.length) ];
                [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
            }
        }else
        {
            if (!self.isHighlighted) {
                if (_isExist) {
                    [titleStr addAttribute: NSForegroundColorAttributeName
                                     value: [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
                                     range: NSMakeRange(0, titleStr.length) ];
                    
                    [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
                }else {
                    [titleStr addAttribute: NSForegroundColorAttributeName
                                     value: [StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]
                                     range: NSMakeRange(0, titleStr.length) ];
                    
                    [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
                }
            }else
            {
                [titleStr addAttribute: NSForegroundColorAttributeName
                                 value: [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
                                 range: NSMakeRange(0, titleStr.length) ];
                
                [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
            }
        }
    }
    
    if (_isLastCell){
        [titleStr addAttribute: NSForegroundColorAttributeName
                         value: [StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]
                         range: NSMakeRange(0, titleStr.length)];
    }
    
    
    if (titleStr != nil) {
        [titleStr addAttribute:NSParagraphStyleAttributeName value:textParagraph range:NSMakeRange(0, [titleStr length])];
        NSRect rect = [self titleRectForBounds:cellFrame];
        [titleStr drawWithRect: rect
                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
        [titleStr release];
    }
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
    /* get the standard text content rectangle */
    NSRect titleFrame = [super titleRectForBounds:theRect];
    
    /* find out how big the rendered text will be */
    NSAttributedString *attrString = self.attributedStringValue;
    NSMutableAttributedString *titleStr = [attrString mutableCopy];
    NSRect textRect = NSZeroRect;
    if (titleStr != nil) {
        textRect = [titleStr boundingRectWithSize: titleFrame.size
                                          options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
        [titleStr release];
    }
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    if (textRect.size.height < titleFrame.size.height) {
        if (_isRighVale) {
            titleFrame.origin.x = titleFrame.origin.x - 8;
        }else{
            titleFrame.origin.x = titleFrame.origin.x + 10;
        }
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
        titleFrame.size.height = textRect.size.height + 2;
        titleFrame.size.width -= 4;
    }
    titleFrame.size.width -= 2;
    return titleFrame;
}
- (NSRect)expansionFrameWithFrame:(NSRect)cellFrame inView:(NSView *)view NS_AVAILABLE_MAC(10_5){
    if (_entity != nil){
        NSString *size = @"";
        NSString *title = @"";
        NSString *path = @"";
        int width = 0;
        if (_category == Category_Movies){
            IMBADVideoTrack *videoTrack = _entity;
            size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),[IMBHelper getFileSizeString:videoTrack.size reserved:2]];
            title = videoTrack.title;
            path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),videoTrack.url];
        }else if (_category == Category_Compressed || _category == Category_Document){
            IMBADFileEntity *adFileEntity = _entity;
            size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),[IMBHelper getFileSizeString:adFileEntity.fileSize reserved:2]];
            title = adFileEntity.title;
            path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),adFileEntity.filePath];
        }else if (_category == Category_Music){
            IMBADAudioTrack *videoTrack = _entity;
            size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),[IMBHelper getFileSizeString:videoTrack.size reserved:2]];
            title = videoTrack.title;
            path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),videoTrack.url];
        }
        NSRect sizeStrRect = [IMBHelper calcuTextBounds:size fontSize:12];
        NSRect titleStrRect = [IMBHelper calcuTextBounds:title fontSize:12];
        NSRect pathStrRect = [IMBHelper calcuTextBounds:path fontSize:12];
        
        if (sizeStrRect.size.width >= titleStrRect.size.width&&sizeStrRect.size.width >= pathStrRect.size.width){
            width = sizeStrRect.size.width +10;
        }else if (titleStrRect.size.width >= sizeStrRect.size.width&&titleStrRect.size.width >= pathStrRect.size.width){
            width = titleStrRect.size.width +10;
        }else if (pathStrRect.size.width >= titleStrRect.size.width &&pathStrRect.size.width > sizeStrRect.size.width){
            width = pathStrRect.size.width +10;
        }
        
        NSRect rect = NSMakeRect(cellFrame.origin.x , cellFrame.origin.y + 40, width, 60);
        return rect;
    }else{
        return [super expansionFrameWithFrame:cellFrame inView:view];
    }
}

/* Allows the cell to perform custom expansion tool tip drawing. Note that the view may be different from the original view that the cell appeared in. By default, NSCell simply calls drawWithFrame:inView:.
 */
- (void)drawWithExpansionFrame:(NSRect)cellFrame inView:(NSView *)view NS_AVAILABLE_MAC(10_5){
    [super drawWithExpansionFrame:cellFrame inView:view];
    if (_entity != nil){
        [[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)] setFill];
        NSRectFill(cellFrame);
        NSString *size = @"";
        NSString *title = @"";
        NSString *path = @"";
        NSString *entitySize = @"";
        NSString *entitypath = @"";
        if (_category == Category_Movies){
            IMBADVideoTrack *videoTrack = _entity;
            entitySize = [IMBHelper getFileSizeString:videoTrack.size reserved:2];
            entitypath = videoTrack.url;
            if ([IMBHelper stringIsNilOrEmpty:entitySize]){
                size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),@"--"];
            }else{
                size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),entitySize];
            }
            if ([IMBHelper stringIsNilOrEmpty:entitypath]){
                path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),@"--"];
            }else {
                path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),entitypath];
            }
            
            title = videoTrack.title;
            
        }else if (_category == Category_Compressed || _category == Category_Document){
            IMBADFileEntity *adFileEntity = _entity;
            entitySize = [IMBHelper getFileSizeString:adFileEntity.fileSize reserved:2];
            entitypath = adFileEntity.filePath;
            if ([IMBHelper stringIsNilOrEmpty:entitySize]){
                size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),@"--"];
            }else{
                size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),entitySize];
            }
            if ([IMBHelper stringIsNilOrEmpty:entitypath]){
                path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),@"--"];
            }else {
                path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),entitypath];
            }
            title = adFileEntity.title;
    
        }else if (_category == Category_Music){
            IMBADAudioTrack *videoTrack = _entity;
            entitySize = [IMBHelper getFileSizeString:videoTrack.size reserved:2];
            entitypath = videoTrack.url;
            if ([IMBHelper stringIsNilOrEmpty:entitySize]){
                size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),@"--"];
            }else{
                size = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"List_Header_id_Size", nil),entitySize];
            }
            if ([IMBHelper stringIsNilOrEmpty:entitypath]){
                path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),@"--"];
            }else {
                path = [NSString stringWithFormat:@"%@: %@",CustomLocalizedString(@"ListToolTip_path", nil),entitypath];
            }
            title = videoTrack.title;
        }
        
        NSRect sizeStrRect = [IMBHelper calcuTextBounds:size fontSize:12];
        NSRect titleStrRect = [IMBHelper calcuTextBounds:title fontSize:12];
        NSRect pathStrRect = [IMBHelper calcuTextBounds:path fontSize:12];
        int width = 0;
        if (sizeStrRect.size.width >= titleStrRect.size.width&&sizeStrRect.size.width >= pathStrRect.size.width){
            width = sizeStrRect.size.width +10;
        }else if (titleStrRect.size.width >= sizeStrRect.size.width&&titleStrRect.size.width >= pathStrRect.size.width){
            width = titleStrRect.size.width +10;
        }else if (pathStrRect.size.width >= titleStrRect.size.width &&pathStrRect.size.width > sizeStrRect.size.width){
            width = pathStrRect.size.width +10;
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],
                             NSFontAttributeName,nil];
        
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:title attributes:dic];
        NSRect titleRect = NSMakeRect(4, 0, width, 22);
        [titleString drawWithRect: titleRect
                          options: NSStringDrawingUsesLineFragmentOrigin];
        [titleString release];
        
        NSMutableAttributedString *sizeString = [[NSMutableAttributedString alloc] initWithString:size attributes:dic];
        NSRect sizeRect = NSMakeRect(4, +20, width, 22);
        [sizeString drawWithRect: sizeRect
                         options: NSStringDrawingUsesLineFragmentOrigin];
        [sizeString release];
        
        NSMutableAttributedString *pathString = [[NSMutableAttributedString alloc] initWithString:path attributes:dic];
        NSRect pathRect = NSMakeRect(4, 40, width, 22);
        [pathString drawWithRect: pathRect
                         options: NSStringDrawingUsesLineFragmentOrigin];
        [pathString release];
    }
}

@end
