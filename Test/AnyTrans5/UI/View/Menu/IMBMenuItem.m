//
//  IMBMenuItem.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMenuItem.h"
#import "StringHelper.h"
@implementation IMBMenuItem
@synthesize badgeCount = _badgeCount;
@synthesize backupnode = _backupnode;
@synthesize functionButton = _functionButton;
- (id)initWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode
{
    if (self = [super initWithTitle:aString action:aSelector keyEquivalent:charCode]) {
        _menuItemView = [[IMBMenuItemView alloc] initWithFrame:NSMakeRect(0, 0, 220, 30)];
        [_menuItemView setMenuItem:self];
        [self setView:_menuItemView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
         _menuItemView = [[IMBMenuItemView alloc] initWithFrame:NSMakeRect(0, 0, 220, 30)];
        [_menuItemView setMenuItem:self];
        [self setView:_menuItemView];
    }
    return self;
}

- (void)setFunctionButton:(IMBFunctionButton *)button
{
    if (_functionButton != button) {
        [_functionButton release];
        _functionButton = [button retain];
        if (button.isContainer) {
            [_menuItemView setTriangle:[StringHelper imageNamed:@"nav_triangle"]];
        }else{
            [self bind:@"badgeCount" toObject:button withKeyPath:@"badgeCount" options:0];
            [self bind:@"enabled" toObject:button withKeyPath:@"enabled" options:0];
            if (button.badgeCount == 0) {
                [_menuItemView setCount:@"--"];
            }else{
                [_menuItemView setCount:[NSString stringWithFormat:@"%d",(int)button.badgeCount]];
            }
        }
        [self setTitle:button.title];
        [button addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [button addObserver:self forKeyPath:@"navagationIcon" options:NSKeyValueObservingOptionNew context:nil];

        [_menuItemView setTitle:button.title];
        [_menuItemView setIcon:button.navagationIcon];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        NSString *title = [change objectForKey:@"new"];
        [self setTitle:title];
    }else if ([keyPath isEqualToString:@"badgeCount"]) {
        NSNumber *count = [change objectForKey:@"new"];
        _badgeCount = [count intValue];
    }else if ([keyPath isEqualToString:@"navagationIcon"]) {
        NSImage *image = [change objectForKey:@"new"];
        [_menuItemView setIcon:image];
    }
}

- (void)setTitle:(NSString *)aString
{
    [_menuItemView setTitle:aString];
}

- (void)setBackupnode:(SimpleNode *)backupnode
{
    if (_backupnode != backupnode) {
        [_backupnode release];
        _backupnode = [backupnode retain];
        if (_backupnode.container) {
            [_menuItemView setTriangle:[StringHelper imageNamed:@"nav_triangle"]];
            [_menuItemView setTitle:_backupnode.deviceName];
            if (_backupnode.productType == iPhoneType) {
                [_menuItemView setIcon:[StringHelper imageNamed:@"nav_iPhone"]];
            }else if (_backupnode.productType == iPadType) {
                [_menuItemView setIcon:[StringHelper imageNamed:@"nav_iPad"]];
            }else if (_backupnode.productType == iPodTouchType) {
                [_menuItemView setIcon:[StringHelper imageNamed:@"nav_ipod_touch"]];
            }else if (_backupnode.productType == iPhonexType) {
                //先把代码加在这儿，以后在对_backupnode.productType赋值
                [_menuItemView setIcon:[StringHelper imageNamed:@"nav_iPhonex"]];
            }
        }else{
            [_menuItemView setTitle:_backupnode.backupDate];
            if (_backupnode.isEncrypt) {
                [_menuItemView setIcon:[StringHelper imageNamed:@"nav_list_lock"]];
            }else{
                [_menuItemView setIcon:[StringHelper imageNamed:@"nav_time"]];
            }
        }
    }
}

- (IMBFunctionButton *)FunctionButton
{
    return _functionButton;
}

- (void)setBadgeCount:(NSInteger)badgeCount
{
    if (_badgeCount != badgeCount) {
        _badgeCount = badgeCount;
        if (_badgeCount == 0) {
            [_menuItemView setCount:@"--"];
        }else{
            [_menuItemView setCount:[NSString stringWithFormat:@"%d",(int)_badgeCount]];
        }
    }
}

- (void)setEnabled:(BOOL)flag
{
    [super setEnabled:flag];
    [_menuItemView setEnable:flag];
}

- (void)setTarget:(id)anObject
{
    [super setTarget:anObject];
    [_menuItemView setTarget:anObject];
}

- (void)setAction:(SEL)aSelector
{
    [super setAction:aSelector];
    [_menuItemView setAction:aSelector];
}

- (NSArray *)exposedBindings
{
    return [NSArray arrayWithObject:@"badgeCount"];
}

- (void)doChangeLanguage:(NSNotification *)notification {
    
}

- (void)dealloc
{
    [_functionButton removeObserver:self forKeyPath:@"title"];
    [_functionButton removeObserver:self forKeyPath:@"navagationIcon"];

    [_backupnode release],_backupnode = nil;
    [_menuItemView release],_menuItemView = nil;
    [_functionButton release],_functionButton = nil;
    [self unbind:@"badgeCount"];
    [super dealloc];
}
@end
