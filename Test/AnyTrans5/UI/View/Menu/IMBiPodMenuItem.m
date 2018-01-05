//
//  IMBiPodMenuItem.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBiPodMenuItem.h"

@implementation IMBiPodMenuItem
@synthesize iPodunique = _iPodunique;

-(void)dealloc
{
    [_iPodunique release],_iPodunique = nil;
    [super dealloc];
}

@end
