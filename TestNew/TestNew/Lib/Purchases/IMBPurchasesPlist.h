//
//  IMBPurchasesPlist.h
//  iMobieTrans
//
//  Created by zhang yang on 13-7-13.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"

@interface IMBPurchasesPlist : NSObject {
    IMBiPod *_iPod;
}

- (id)initWithiPod:(IMBiPod *)iPod;
-(NSMutableArray*) getPurchasesFromPlist;
//windows下用来
//public bool CheckForUpdate(DateTime LastUpdateTime)


@end
