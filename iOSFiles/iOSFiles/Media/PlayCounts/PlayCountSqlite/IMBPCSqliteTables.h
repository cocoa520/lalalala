//
//  IMBPCSqliteTables.h
//  iMobieTrans
//
//  Created by Pallas on 1/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@class IMBiPod;

@interface IMBPCSqliteTables : NSObject {
@protected
    IMBiPod *iPod;
    FMDatabase *_dynamicConnection, *_mediaLibraryConnection;
}

- (id)initWithIPod:(IMBiPod*)ipod;
- (NSMutableArray*)getPlayCoutsAndRating;

@end
