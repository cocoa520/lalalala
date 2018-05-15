//
//  IMBCloudEntity.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCloudEntity.h"

@implementation IMBCloudEntity
@synthesize name = _name;
@synthesize email = _email;
@synthesize image = _image;
@synthesize driveID = _driveID;
@synthesize categoryCloudEnum = _categoryCloudEnum;
@synthesize isBottomItem = _isBottomItem;
@synthesize lastVisitTime = _lastVisitTime;
@synthesize totalSize = _totalSize;
@synthesize availableSize = _availableSize;
@synthesize usersNumber = _usersNumber;
@synthesize cloudAry = _cloudAry;
@synthesize isClick = _isClick;
@synthesize category = _category;
@synthesize service = _service;
@synthesize popular = _popular;
@synthesize isHidden = _isHidden;
@synthesize showSize = _showSize;
@synthesize isAddHidden = _isAddHidden;
-(instancetype)init {
    if (self = [super init]) {
        _totalSize = 0;
        _availableSize = 0;
    }
    return self;
}

- (void)setUsersNumber:(int)usersNumber {
    _usersNumber = usersNumber;
    if (_usersNumber > 0) {
        _isHidden = NO;
    }else {
        _isHidden = YES;
    }
}

-(void)dealloc {
    [super dealloc];
}
@end
