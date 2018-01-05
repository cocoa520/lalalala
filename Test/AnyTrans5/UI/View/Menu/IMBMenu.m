//
//  IMBMenu.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-7.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMenu.h"

@implementation IMBMenu


- (void)cancelTracking
{
    [super cancelTracking];
}

- (void)cancelTrackingWithoutAnimation
{
    [super cancelTrackingWithoutAnimation];
}

- (BOOL)allowsContextMenuPlugIns
{

    return YES;
}


//- (BOOL)_hasPaddingOnEdge:(BOOL)hasPadding
//{
//    return NO;
//
//}

- (NSInteger)numberOfItems
{
    NSLog(@"sdfsdfsdfsdf");
    return [super numberOfItems];
}
@end
