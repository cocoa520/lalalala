//
//  IMBBaseEntity.m
//  PhoneRescue
//
//  Created by iMobie on 3/22/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"

@implementation IMBBaseEntity
@synthesize checkState = _checkState;
@synthesize isDeleted = _isDeleted;
@synthesize selectedCount = _selectedCount;
@synthesize deleteCount = _deleteCount;
@synthesize isHaveExistAndDeleted = _isHaveExistAndDeleted;
@synthesize sortStr = _sortStr;
@synthesize isHiddenSelectImage;

- (id)init
{
    if (self = [super init]) {
        [self setCheckState:UnChecked];
        _isDeleted = NO;
        _selectedCount = 0;
        _deleteCount = 0;
        _isHaveExistAndDeleted = NO;
        _sortStr = [@"" retain];
        isHiddenSelectImage = YES;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc
{
    [_sortStr release],_sortStr = nil;
    [super dealloc];
}

@end
