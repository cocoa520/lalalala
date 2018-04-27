//
//  IMBPCSqliteTables.m
//  iMobieTrans
//
//  Created by Pallas on 1/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBPCSqliteTables.h"

@implementation IMBPCSqliteTables

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [super init];
    if (self) {
        iPod = ipod;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (NSMutableArray*)getPlayCoutsAndRating {
    return nil;
}

@end
