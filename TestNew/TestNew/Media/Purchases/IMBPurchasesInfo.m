//
//  IMBPurchasesInfo.m
//  iMobieTrans
//
//  Created by zhang yang on 13-7-13.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBPurchasesInfo.h"
#import "IMBPurchasesPlist.h"
#import "IMBPurchasesSqlite.h"

@implementation IMBPurchasesInfo
@synthesize hasPurchases = _hasPurchases;
@synthesize lastUpdateTime = _lastUpdateTime;
@synthesize purchasesTracks = _purchasesTracks;


- (id)initWithiPod:(IMBiPod *)iPod
{
    self = [super init];
    if (self) {
        //_purchasesTracks = [[NSMutableArray alloc] init];
        NSLog(@"_iPod key %@",iPod.uniqueKey);
        _iPod = iPod;
        [self refreshPurchases];
    }
    return self;
}

- (void)dealloc
{
    if (_purchasesTracks != nil) {
        [_purchasesTracks release];
        _purchasesTracks = nil;
    }
    [super dealloc];
}

- (void) refreshPurchases {
    if (_purchasesTracks != nil) {
        [_purchasesTracks release];
        _purchasesTracks = nil;
    }
    //1.得到从sqlite里面的purchase信息
    IMBPurchasesSqlite *purS = [[IMBPurchasesSqlite alloc] initWithiPod:_iPod];
    _purchasesTracks = [[purS getPurchasesTrackList] retain];
    [purS release];
    //2.得到artwork信息
    IMBPurchasesPlist *purP = [[IMBPurchasesPlist alloc] initWithiPod:_iPod];
    NSArray *trackPlistTracks = [purP getPurchasesFromPlist];
    if (trackPlistTracks.count > 0) {
        for (IMBTrack* track in _purchasesTracks) {
            NSArray *filterArray = [trackPlistTracks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"dbID == %lld",track.dbID]];
            if (filterArray.count > 0) {
                if ([track.artworkPath isEqualToString: @""]) {
                    track.artworkPath = [(IMBTrack*)[filterArray objectAtIndex:0] artworkPath];
                }
                
            }
        }
    }
}

@end
