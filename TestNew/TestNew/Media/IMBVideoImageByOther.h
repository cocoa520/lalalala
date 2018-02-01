//
//  IMBVideoImageByOther.h
//  iMobieTrans
//
//  Created by iMobie on 12/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"

@interface IMBVideoImageByOther : NSObject {
    IMBiPod *_ipod;
    NSString *_oriPath;  //视屏device路径
    NSString *_videoImagePath;
}

- (id)initWithPath:(NSString *)path withiPod:(IMBiPod *)ipod;
- (NSString *)getVideoImageInfo;

@end
