//
//  IMBBaseDelete.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-4.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseDelete.h"
#import "IMBTracklist.h"
#import "IMBPurchasesInfo.h"
@implementation IMBBaseDelete
@synthesize delegate = _delegate;

- (id)initWithIPod:(IMBiPod *)ipod deleteArray:(NSMutableArray *)deleteArray
{
    if (self = [super init]) {
        _ipod = [ipod retain];
        _deleteArray = [deleteArray retain];
        _logManager = [IMBLogManager singleton];
    }
    return self;
}

- (void)startDelete{}

-(void)removeTrackByTrack:(IMBTrack*)track {
    //如果是Purchase就直接加入到deleteTracks里面
    //为页面刷新用Start
    //为页面刷新用End
    if (track.isPurchase == true ) {
        [_ipod.purchasesInfo.purchasesTracks removeObject:track];
        [_ipod.session.deletedTracks addObject:track];
        return;
    }
    long long dbID = [track dbID];
    //这里可以直接加入到dirty track里面
    IMBTrack *delTrack = [[_ipod tracks] findByDBID:dbID];
    if (delTrack != nil) {
        [[_ipod tracks] removeTrack:delTrack];
    }
}

- (void)dealloc{
    [_deleteArray release],_deleteArray = nil;
    [_ipod release],_ipod = nil;
    [super dealloc];
}
@end
