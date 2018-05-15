//
//  IMBRightKeyMenu.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/11.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBRightKeyMenu.h"
#import "IMBMoreMenuView.h"
#import "IMBCustomView.h"
#import "IMBBaseViewController.h"

@interface IMBRightKeyMenu ()

@end

@implementation IMBRightKeyMenu

- (id)initWithDelegate:(id)delegate withBtnArray:(NSArray *)btnArray {
    if (self = [super initWithWindowNibName:@"IMBRightKeyMenu"]) {
        _menuArr = [NSArray arrayWithArray:btnArray];
        _delegate = delegate;
        
    }
    return self;
}

-(void)awakeFromNib {
    int menuHeight = (int)(_menuArr.count - 1) * 39 + 24;
    [self.window setMinSize:NSMakeSize(180, menuHeight)];
    [self.window setMaxSize:NSMakeSize(180, menuHeight)];
    [self.window.contentView setFrameSize:NSMakeSize(180, menuHeight)];
    [_menuBgView setFrameSize:NSMakeSize(180, menuHeight)];
    
    self.window.opaque = NO;
    self.window.backgroundColor=[NSColor clearColor];
    for (int itemTag = 1; itemTag < _menuArr.count; itemTag++) {
        IMBCustomView *bgView = [[IMBCustomView alloc] initWithFrame:NSMakeRect(0, menuHeight - 12 - itemTag*39, 180, 39)];
        IMBMoreItem *item = [[IMBMoreItem alloc] initWithFrame:NSMakeRect(-3, 0, 183, 39)];
        [item setItemTag:itemTag];
        [item setActionType:[[_menuArr objectAtIndex:itemTag - 1] intValue]];
        [item setTarget:self];
        [item setAction:@selector(rightKeyMenuItemClick:)];
        [bgView addSubview:item];
        [_menuBgView addSubview:bgView];
        [item release];
        item = nil;
        [bgView release];
        bgView = nil;
    }
}

- (void)rightKeyMenuItemClick:(id)sender {
    [_delegate rightKeyMenuClick:sender];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
