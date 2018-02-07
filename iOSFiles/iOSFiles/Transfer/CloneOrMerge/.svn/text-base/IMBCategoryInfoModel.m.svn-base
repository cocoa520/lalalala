//
//  IMBCagetoryInfoModel.m
//  iMobieTrans
//
//  Created by iMobie on 7/24/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCategoryInfoModel.h"
#import "StringHelper.h"

@implementation IMBCategoryInfoModel
@synthesize categoryImage = _categoryImage;
@synthesize categoryName = _categoryName;
@synthesize categoryNodes = _categoryNodes;
@synthesize isSelected = _isSelected;
@synthesize categoryNameAs = _categoryNameAs;

- (id)init
{
    self = [super init];
    if (self) {
        _categoryName = @"";
        _categoryImage = nil;
        _categoryNodes = Category_Summary;
        _isSelected = NO;
    }
    return self;
}

- (void)setCategoryNameAttributedString {
    NSMutableAttributedString *as = [[[NSMutableAttributedString alloc] initWithString:_categoryName] autorelease];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [self setCategoryNameAs:as];
}

- (void)dealloc
{
    [_categoryImage release],_categoryImage = nil;
    [_categoryName release],_categoryName = nil;
    [super dealloc];
}
@end
