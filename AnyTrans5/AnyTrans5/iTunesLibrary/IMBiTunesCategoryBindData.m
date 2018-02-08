//
//  IMBiTunesCategoryBindData.m
//  iMobieTrans
//
//  Created by Pallas on 7/30/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBiTunesCategoryBindData.h"

@implementation IMBiTunesCategoryBindData
@synthesize categoryName = _categoryName;
@synthesize displayName = _displayName;
@synthesize categoryIcon = _categoryIcon;
@synthesize categoryIcon1 = _categoryIcon1;
@synthesize isSelected = _isSelected;
@synthesize categoryView = _categoryView;
@synthesize isHigLight = _isHigLight;
@synthesize imageStrName = _imageStrName;
- (id)init {
    self = [super init];
    if (self) {
        _categoryName = nil;
        _displayName = nil;
        _categoryIcon = nil;
        _categoryIcon1 = nil;
        _isSelected = NO;
        _categoryView = nil;
        _isHigLight = NO;
        _imageStrName = @"";
    }
    return self;
}

- (void)setCategoryIcon:(NSImage *)categoryIcon {
    if (_categoryIcon != nil) {
        [_categoryIcon release];
        _categoryIcon = nil;
    }
    _categoryIcon = [categoryIcon retain];
}

- (void)dealloc {
    if (_categoryIcon != nil) {
        [_categoryIcon release];
        _categoryIcon = nil;
    }
    [super dealloc];
}

@end
