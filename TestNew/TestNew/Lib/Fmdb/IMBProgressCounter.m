//
//  IMBProgressCounter.m
//  iMobieTrans
//
//  Created by iMobie on 8/14/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBProgressCounter.h"

@implementation IMBProgressCounter
@synthesize prepareCurrentIndex = _prepareCurrentIndex;
@synthesize prepareTotalCount = _prepareTotalCount;
@synthesize prepareTotalMediaCount = _prepareTotalMediaCount;
@synthesize copyingCurrentIndex = _copyingCurrentIndex;
@synthesize copyingTotalCount = _copyingTotalCount;
@synthesize prepareAnalysisSuccessCount = _prepareAnalysisSuccessCount;
@synthesize prepareAnalysisOutOfCount = _prepareAnalysisOutOfCount;
@synthesize isOutOfStorage = _isOutOfStorage;

+ (IMBProgressCounter *)singleton{
    static IMBProgressCounter *singleton = nil;
    @synchronized(self){
        if (singleton == nil) {
            singleton = [[IMBProgressCounter alloc] init];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];

        }
    }
    return singleton;
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    [self dealloc];
}

- (void)reInit{
    _prepareCurrentIndex = 0;
    _prepareTotalCount = 0;
    _prepareTotalMediaCount = 0;
    _copyingCurrentIndex = 0;
    _copyingTotalCount = 0;
    _prepareAnalysisSuccessCount = 0;
    _prepareAnalysisOutOfCount = NO;
    _isOutOfStorage = NO;
}

- (void)setPrepareAnalysisSuccessCount:(int)prepareAnalysisSuccessCount{
    _prepareAnalysisSuccessCount  = prepareAnalysisSuccessCount;
}

- (void)setPrepareTotalCount:(int)prepareTotalCount
{
    _prepareTotalCount = prepareTotalCount;
}

- (void)setPrepareAnalysisOutOfCount:(BOOL)prepareAnalysisOutOfCount{
    _prepareAnalysisOutOfCount = prepareAnalysisOutOfCount;
}

- (void)setCopyingTotalCount:(int)copyingTotalCount{
    _copyingTotalCount = copyingTotalCount;
}

- (void)setMediaCopyingTotalCount:(int)count{
    _copyingTotalCount = _prepareTotalCount - _prepareTotalMediaCount + count;
}

@end
