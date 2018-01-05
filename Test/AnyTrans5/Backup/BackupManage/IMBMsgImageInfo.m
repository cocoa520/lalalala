//
//  IMBMsgImageInfo.m
//  iMobieTrans
//
//  Created by iMobie on 8/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBMsgImageInfo.h"

@implementation IMBMsgImageInfo
@synthesize msgImage = _msgImage;
@synthesize msgRect = _msgRect;

- (id)init
{
    self = [super init];
    if (self) {
        _msgRect = NSMakeRect(15, 15, 0, 0);
        _msgImage = nil;
    }
    return self;
}

@end
