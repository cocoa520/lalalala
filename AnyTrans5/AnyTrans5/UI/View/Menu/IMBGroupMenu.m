//
//  IMBGroupMenu.m
//  AnyTrans
//
//  Created by smz on 17/7/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBGroupMenu.h"
#import "IMBGroupMenuItem.h"
#import "IMBCalendarEntity.h"

@implementation IMBGroupMenu

- (id)initWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode
{
    if (self = [super initWithTitle:aString action:aSelector keyEquivalent:charCode]) {
        _itemView = [[IMBGroupMenuItem alloc] initWithFrame:NSMakeRect(0, 0, 180, 30)];
        [_itemView setMenuItem:self];
        [self setView:_itemView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemView = [[IMBGroupMenuItem alloc] initWithFrame:NSMakeRect(0, 0, 180, 30)];
        [_itemView setMenuItem:self];
        [self setView:_itemView];
    }
    return self;
}

- (void)setTitle:(NSString *)aString
{
    [_itemView setTitle:aString];
}

- (void)setTag:(NSInteger)anInt {
    [_itemView setTag:anInt];
}

- (void)setGroupColor:(NSColor *)groupColor {
    [_itemView setGroupColor:groupColor];
}

- (void)setEnabled:(BOOL)flag
{
    [super setEnabled:flag];
}

- (void)setTarget:(id)anObject
{
    [super setTarget:anObject];
    [_itemView setTarget:anObject];
}

- (void)setAction:(SEL)aSelector
{
    [super setAction:aSelector];
    [_itemView setAction:aSelector];
}

- (void)dealloc
{
    [_itemView release],_itemView = nil;
    [super dealloc];
}

@end
