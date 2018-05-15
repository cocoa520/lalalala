//
//  IMBTranferBtnManager.m
//  AllFiles
//
//  Created by 龙凡 on 2018/5/12.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTranferBtnManager.h"

@implementation IMBTranferBtnManager
@synthesize tranferAry = _tranferAry;

-(instancetype)init {
    if ([super init]) {
        _tranferAry = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (IMBTranferBtnManager*)singleton {
    static IMBTranferBtnManager *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBTranferBtnManager alloc] init];
        }
    }
    return _singleton;
}

-(void)dealloc {
    [super dealloc];
    if (_tranferAry) {
        [_tranferAry release];
        _tranferAry = nil;
    }
}

@end
