//
//  IMBScanEntity.m
//  PhoneRescue_Android
//
//  Created by smz on 17/4/19.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBScanEntity.h"

@implementation IMBScanEntity
@synthesize name = _name;
@synthesize imageName = _imageName;
@synthesize scanType = _scanType;
@synthesize scanStatue = _scanStatue;
@synthesize count = _count;
@synthesize isSubNode = _isSubNode;
@synthesize isHaveValue = _isHaveValue;
@synthesize animaView = _animaView;
@synthesize noValueImgName = _noValueImgName;
//@synthesize animationView = _animationView;
@synthesize image = _image;
@synthesize bindingImage = _bindingImage;
@synthesize sonAryCount = _sonAryCount;
@synthesize bingdingTag = _bingdingTag;
@synthesize index = _index;
@synthesize searchStr = _searchStr;
@synthesize toDeviceImage = _toDeviceImage;

-(id)init{
    if ([super init]) {
        _checkState = UnChecked;
        _isHaveValue = YES;
//        _animationView = [[IMBScanCirAnimation alloc]initWithFrame:NSMakeRect(0, 0, 30, 20)];
        _searchStr = @"";
    }
    return self;
}

@end

@implementation IMBResultEntity
@synthesize reslutCount = _reslutCount;
@synthesize reslutSize = _reslutSize;
@synthesize scanType = _scanType;
@synthesize reslutArray = _reslutArray;
@synthesize totalAttachmentSize = _totalAttachmentSize;
@synthesize deleteReslutCount = _deleteReslutCount;

- (id)init {
    if (self = [super init]) {
        _reslutCount = 0;
        _reslutSize = 0;
        _scanType = 0;
        _totalAttachmentSize = 0;
        _deleteReslutCount = 0;
        _reslutArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reInit {
    _reslutCount = 0;
    _reslutSize = 0;
    _scanType = 0;
    _totalAttachmentSize = 0;
    _deleteReslutCount = 0;
    _deleteCount = 0;
    _selectedCount = 0;
    [self setCheckState:Check];
    _isDeleted = NO;
    _isHaveExistAndDeleted = NO;
    _sortStr = @"";
    if (_reslutArray != nil) {
        [_reslutArray release];
        _reslutArray = nil;
    }
    _reslutArray = [[NSMutableArray alloc] init];
}

- (void)dealloc
{
    [_reslutArray release],_reslutArray = nil;
    [super dealloc];
}

@end
