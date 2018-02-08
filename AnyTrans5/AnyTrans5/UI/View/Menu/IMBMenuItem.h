//
//  IMBMenuItem.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBFunctionButton.h"
#import "IMBMenuItemView.h"
#import "SimpleNode.h"
@interface IMBMenuItem : NSMenuItem
{
    IMBFunctionButton *_functionButton; //数据源对象
    SimpleNode *_backupnode; //备份的数据源对象
    IMBMenuItemView *_menuItemView;
    NSInteger _badgeCount;
}
@property (nonatomic,assign)NSInteger badgeCount;
@property (nonatomic,retain)SimpleNode *backupnode;
@property (nonatomic,retain)IMBFunctionButton *functionButton;
- (void)setFunctionButton:(IMBFunctionButton *)button;
- (IMBFunctionButton *)FunctionButton;
@end
