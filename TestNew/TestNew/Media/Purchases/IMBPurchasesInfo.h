//
//  IMBPurchasesInfo.h
//  iMobieTrans
//
//  Created by zhang yang on 13-7-13.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBTrack.h"
#import "IMBiPod.h"

// title, time, airtist, album, genre, playcount, rating, filesize,
// 非显示字段， track的地址 location, is_video, purchases

@interface IMBPurchasesInfo : NSObject {
    BOOL _hasPurchases;
    NSString* _lastUpdateTime;
    NSMutableArray *_purchasesTracks;
    IMBiPod *_iPod;
    
}


@property (nonatomic, readwrite,assign) BOOL hasPurchases;
@property (nonatomic, readwrite, retain) NSString *lastUpdateTime;
@property (nonatomic, readwrite, retain) NSMutableArray *purchasesTracks;

- (id)initWithiPod:(IMBiPod *)iPod;

- (void) refreshPurchases;




@end
