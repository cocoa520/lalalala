//
//  IMBTrackListContainer.m
//  MediaTrans
//
//  Created by Pallas on 12/16/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBTrackListContainer.h"

@implementation IMBTrackListContainer

#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if(self){
        //初始化对象的值
    }
    return self;
}

-(id)initWithParent:(id)parent{
    self = [super init];
    if (self) {
        _header = parent;
    }
    return self;
}

-(void)dealloc{
    if (_childSection) {
        [_childSection release];
        _childSection = nil;
    }
    [super dealloc];
}

#pragma mark - 重写方法
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    _childSection = [[IMBTracklist alloc] init];
    currPosition = [_childSection read:iPod reader:reader currPosition:currPosition];
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    [_childSection write:writer];
}

-(int)getSectionSize{
    return [_header headerSize] + [_childSection getSectionSize];
}

#pragma mark - 实现声明方法
-(IMBTracklist*)getTracklist{
    return _childSection;
}

@end
