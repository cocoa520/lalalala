//
//  IMBNavigationViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
@interface IMBNavigationViewController : NSViewController<InnerViewSwitchDelegate>
{
    NSBox *_contentBox;
    NSMutableArray *_stackArray;
    NSViewController *_currentViewController;
}
@property (nonatomic,assign)NSViewController *currentViewController;
- (id)initWithRootViewController:(IMBBaseViewController *)rootViewController box:(NSBox *)box;
- (NSMutableArray *)viewControllers;
@end
