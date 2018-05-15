//
//  IMBTableHeaderView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBTableHeaderView.h"
#import "StringHelper.h"

#define ARROWSPACE 5
#define ARROWY 0
@implementation IMBTableHeaderView

- (void)awakeFromNib {
    _nameArrow = [[IMBArrowButton alloc] initWithFrame:NSMakeRect(0, 0, 14, 38)];
    _timeArrow = [[IMBArrowButton alloc] initWithFrame:NSMakeRect(0, 0, 14, 38)];
    _sizeArrow = [[IMBArrowButton alloc] initWithFrame:NSMakeRect(0, 0, 14, 38)];
    _extensionArrow = [[IMBArrowButton alloc] initWithFrame:NSMakeRect(0, 0, 14, 38)];
    [_nameArrow setIsHightLight:YES];
    [_timeArrow setIsHightLight:YES];
    [_sizeArrow setIsHightLight:YES];
    [_extensionArrow setIsHightLight:YES];
    
    [_nameArrow setIdentifier:@"name"];
    [_timeArrow setIdentifier:@"date"];
    [_sizeArrow setIdentifier:@"size"];
    [_extensionArrow setIdentifier:@"extension"];
    
    [self addSubview:_nameArrow];
    [self addSubview:_timeArrow];
    [self addSubview:_sizeArrow];
    [self addSubview:_extensionArrow];
}

- (void)setAction:(SEL)action {
    [_nameArrow setAction:action];
    [_timeArrow setAction:action];
    [_sizeArrow setAction:action];
    [_extensionArrow setAction:action];
}

- (void)setTarget:(id)target {
    [_nameArrow setTarget:target];
    [_timeArrow setTarget:target];
    [_sizeArrow setTarget:target];
    [_extensionArrow setTarget:target];
}

- (void)currentButtonClick:(NSString *)identifier {
    if ([identifier isEqualToString:@"name"]) {
        [_nameArrow setIsHightLight:NO];
        [_timeArrow setIsHightLight:YES];
        [_sizeArrow setIsHightLight:YES];
        [_extensionArrow setIsHightLight:YES];
    } else if ([identifier isEqualToString:@"date"]) {
        [_nameArrow setIsHightLight:YES];
        [_timeArrow setIsHightLight:NO];
        [_sizeArrow setIsHightLight:YES];
        [_extensionArrow setIsHightLight:YES];
    } else if ([identifier isEqualToString:@"size"]) {
        [_nameArrow setIsHightLight:YES];
        [_timeArrow setIsHightLight:YES];
        [_sizeArrow setIsHightLight:NO];
        [_extensionArrow setIsHightLight:YES];
    } else if ([identifier isEqualToString:@"extension"]) {
        [_nameArrow setIsHightLight:YES];
        [_timeArrow setIsHightLight:YES];
        [_sizeArrow setIsHightLight:YES];
        [_extensionArrow setIsHightLight:NO];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    [bgPath fill];
    [bgPath closePath];
    
    NSRect lineRect = NSMakeRect(0, dirtyRect.size.height - 1, dirtyRect.size.width, 1);
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
    NSBezierPath *linePath = [NSBezierPath bezierPathWithRect:lineRect];
    [linePath fill];
    [linePath closePath];
    
//    int nameX = 38;
//    int sizeX = ceil(dirtyRect.size.width / 2.05);
//    int dateX = ceil(dirtyRect.size.width / 1.52);
//    int extensionX = ceil(dirtyRect.size.width / 1.133);
    int nameX = 38;
    float sizeX = 475 *(self.frame.size.width / 972.0);
    float dateX = 640 *(self.frame.size.width / 972.0);
    float extensionX = 858 *(self.frame.size.width / 972.0);
    
    //画标题
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    NSColor *color = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
    
    NSString *headerTitle1 = CustomLocalizedString(@"List_Header_Name_1", nil);
    NSMutableAttributedString *attrStr1 = [StringHelper setTextWordStyle:headerTitle1 withFont:font withLineSpacing:5.0 withAlignment:NSTextAlignmentLeft withColor:color];
    NSRect textRect1 = [StringHelper calcuTextBounds:headerTitle1 font:font];
    textRect1 = NSMakeRect(nameX, 10, textRect1.size.width, textRect1.size.height);
    [attrStr1 drawInRect:textRect1];
    [_nameArrow setFrame:NSMakeRect(textRect1.size.width + nameX + ARROWSPACE, ARROWY, sizeX - nameX - textRect1.size.width - ARROWSPACE, 38)];
    
    
    NSString *headerTitle2 = CustomLocalizedString(@"List_Header_Name_2", nil);
    NSMutableAttributedString *attrStr2 = [StringHelper setTextWordStyle:headerTitle2 withFont:font withLineSpacing:5.0 withAlignment:NSTextAlignmentLeft withColor:color];
    NSRect textRect2 = [StringHelper calcuTextBounds:headerTitle2 font:font];
    textRect2 = NSMakeRect(sizeX, 10, textRect2.size.width, textRect2.size.height);
    [attrStr2 drawInRect:textRect2];
    [_sizeArrow setFrame:NSMakeRect(textRect2.size.width + sizeX + ARROWSPACE, ARROWY, dateX - sizeX - textRect2.size.width - ARROWSPACE, 38)];
    
    NSString *headerTitle3 = CustomLocalizedString(@"List_Header_Name_3", nil);
    NSMutableAttributedString *attrStr3 = [StringHelper setTextWordStyle:headerTitle3 withFont:font withLineSpacing:5.0 withAlignment:NSTextAlignmentLeft withColor:color];
    NSRect textRect3 = [StringHelper calcuTextBounds:headerTitle3 font:font];
    textRect3 = NSMakeRect(dateX, 10, textRect3.size.width, textRect3.size.height);
    [attrStr3 drawInRect:textRect3];
    [_timeArrow setFrame:NSMakeRect(textRect3.size.width + dateX + ARROWSPACE, ARROWY, extensionX - dateX - textRect3.size.width - ARROWSPACE, 38)];
    
    NSString *headerTitle4 = CustomLocalizedString(@"List_Header_Name_4", nil);
    NSMutableAttributedString *attrStr4 = [StringHelper setTextWordStyle:headerTitle4 withFont:font withLineSpacing:5.0 withAlignment:NSTextAlignmentLeft withColor:color];
    NSRect textRect4 = [StringHelper calcuTextBounds:headerTitle4 font:font];
    textRect4 = NSMakeRect(extensionX, 10, textRect4.size.width, textRect4.size.height);
    [attrStr4 drawInRect:textRect4];
    [_extensionArrow setFrame:NSMakeRect(textRect4.size.width + extensionX + ARROWSPACE, ARROWY, dirtyRect.size.width - extensionX, 38)];
}

@end
