//
//  IMBViewManager.m
//  iOSFiles
//
//  Created by iMobie on 3/20/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBViewManager.h"

static id _instance = nil;

@interface IMBViewManager()<NSCopying>

@end

@implementation IMBViewManager
@synthesize allMainControllerDic = _allMainControllerDic;
@synthesize windowDic = _windowDic;
@synthesize mainViewController = _mainViewController;
@synthesize mainWindowController = _mainWindowController;
#pragma mark -- 单例实现
+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMBViewManager alloc] init];
    });
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

/**
 *  销毁操作
 */
- (void)dealloc {
    [_allMainControllerDic release],_allMainControllerDic = nil;
    [_windowDic release],_windowDic = nil;
    [_mainViewController release],_mainViewController = nil;
    [_mainWindowController release],_mainWindowController = nil;
    [super dealloc];
}

#pragma mark --  初始化操作

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
/**
 *  初始化操作
 */
- (void)setUp {
    _allMainControllerDic = [[NSMutableDictionary alloc]init];
    _windowDic = [[NSMutableDictionary alloc]init];
}

//- (void)setMainWindowController:(IMBMainWindowController *)mainWindowController {
//    if (_mainWindowController) {
//        [_mainWindowController release];
//        _mainWindowController = nil;
//    }
//    _mainWindowController = [mainWindowController retain];
//}

@end
