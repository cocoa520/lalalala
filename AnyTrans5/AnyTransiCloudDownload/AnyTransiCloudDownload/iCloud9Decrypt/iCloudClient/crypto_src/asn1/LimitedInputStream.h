//
//  LimitedInputStream.h
//  crypto
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "CategoryExtend.h"

@interface LimitedInputStream : Stream {
@protected
    Stream *_iN;
@private
    int _limit;
}

@property (nonatomic, readwrite, retain) Stream *iN;

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt;
- (int)getRemaining;
- (void)setParentEofDetect:(BOOL)paramBoolean;

@end
