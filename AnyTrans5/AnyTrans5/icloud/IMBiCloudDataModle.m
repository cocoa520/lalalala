//
//  IMBiCloudDataModle.m
//  AnyTrans
//
//  Created by long on 16-10-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBiCloudDataModle.h"

@implementation IMBiCloudDataModle
@synthesize allIcloudDataAry = _allIcloudDataAry;
+ (IMBiCloudDataModle *)singleton {
    static IMBiCloudDataModle *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBiCloudDataModle alloc] init];
        }
    }
    return _singleton;
}

-(id)init{
    if ([super init]) {
        _allIcloudDataAry = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    if (_allIcloudDataAry != nil) {
        [_allIcloudDataAry release];
        _allIcloudDataAry = nil;
    }
}
@end
