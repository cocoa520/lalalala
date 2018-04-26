//
//  ZLEndMark.m
//  iOSFiles
//
//  Created by iMobie on 18/2/27.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "ZLEndMark.h"

@implementation ZLEndMark



+ (instancetype)end {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    return instance;
}

@end
