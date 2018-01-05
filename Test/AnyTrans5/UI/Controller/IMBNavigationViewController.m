//
//  IMBNavigationViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBNavigationViewController.h"

@interface IMBNavigationViewController ()

@end

@implementation IMBNavigationViewController
@synthesize currentViewController = _currentViewController;
- (id)initWithRootViewController:(IMBBaseViewController *)rootViewController box:(NSBox *)box
{
    if (self = [super init]) {
        //压入栈底
        _stackArray = [[NSMutableArray array] retain];
        _contentBox = box;
        [_stackArray addObject:rootViewController];
        _currentViewController = rootViewController;
        rootViewController.navigationController = self;
    }
    return self;
}

- (NSMutableArray *)viewControllers
{
    return _stackArray;
}
#pragma mark - InnerViewSwitchDelegate
///<将视图推入到当前页面
- (void)pushViewController:(IMBBaseViewController *)viewController AnimationStyle:(AnimationStyle)animationStyle
{
    // to do 根据情况添加动画
    viewController.navigationController = self;
    [_contentBox.layer removeAllAnimations];
    [_contentBox setContentView:viewController.view];
    [viewController.view setFrameOrigin:NSMakePoint(NSMinX(viewController.view.bounds), NSMinY(viewController.view.bounds))];
    [_stackArray addObject:viewController];

}
//将视图推出当前页面
- (void)popViewController:(IMBBaseViewController *)viewController AnimationStyle:(AnimationStyle)animationStyle
{
    if ([_stackArray count]>1) {
        IMBBaseViewController *controller = [self previousViewController:viewController];
        _currentViewController = controller;
        [controller.view setFrameOrigin:NSMakePoint(NSMinX(viewController.view.bounds), NSMinY(viewController.view.bounds))];
        [_contentBox setContentView:controller.view];
        [_stackArray removeObject:viewController];
    }
}
//将视图推出到根页面
- (void)popRootViewController:(AnimationStyle)animationStyle
{
    NSMutableArray *array = [NSMutableArray array];
    IMBBaseViewController *controller = nil;
    for (int i=0;i<[_stackArray count];i++) {
        
        if (i != 0) {
            [array addObject:[_stackArray objectAtIndex:i]];
        }else
        {
            controller = [_stackArray objectAtIndex:i];
        }
    }
    
    [_stackArray removeObjectsInArray:array];
    _currentViewController = controller;
    [_contentBox setContentView:controller.view];
}

- (IMBBaseViewController *)previousViewController:(IMBBaseViewController *)viewControler
{
    IMBBaseViewController *previousController = nil;
    int j=0;
    for (int i=0;i<[_stackArray count];i++) {
        IMBBaseViewController *controller = [_stackArray objectAtIndex:i];
        if (controller == viewControler) {
            j = i-1;
        }
    }
    if ([_stackArray count]>=1&&j>=0) {
        previousController = [_stackArray objectAtIndex:j];
    }
    return previousController;
}

- (void)dealloc
{
    [_stackArray release],_stackArray = nil;
    [ super dealloc];
}
@end
