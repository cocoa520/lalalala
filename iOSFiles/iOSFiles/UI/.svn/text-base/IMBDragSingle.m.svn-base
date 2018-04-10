//
//  IMBDragSingle.m
//  AllFiles
//
//  Created by hym on 10/04/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDragSingle.h"
static id _instance = nil;
@implementation IMBDragSingle
@synthesize dragSource = _dragSource;
@synthesize dragDestination = _dragDestination;
@synthesize dragEnd = _dragEnd;
@synthesize dragToOtherWindow = _dragToOtherWindow;

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMBDragSingle alloc] init];
    });
    return _instance;
}



@end
