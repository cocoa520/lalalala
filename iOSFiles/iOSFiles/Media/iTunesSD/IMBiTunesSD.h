//
//  IMBiTunesSD.h
//  iMobieTrans
//
//  Created by Pallas on 1/23/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMBiPod;
@class IMBSDHeader;

@interface IMBiTunesSD : NSObject {
@private
    IMBiPod *iPod;
    IMBSDHeader *_header;
}

- (id)initWithIPod:(IMBiPod*)ipod;

- (void)backup;
- (void)generate;

@end
