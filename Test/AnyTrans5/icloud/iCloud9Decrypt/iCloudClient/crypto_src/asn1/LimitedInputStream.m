//
//  LimitedInputStream.m
//  crypto
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "LimitedInputStream.h"
#import "IndefiniteLengthInputStream.h"

@interface LimitedInputStream ()

@property (nonatomic, assign) int limit;

@end

@implementation LimitedInputStream
@synthesize iN = _iN;
@synthesize limit = _limit;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setIN:nil];
    [super dealloc];
#endif
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt
{
    if (self = [super init]) {
        self.iN = paramInputStream;
        self.limit = paramInt;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getRemaining {
    return self.limit;
}

- (void)setParentEofDetect:(BOOL)paramBoolean {
    if ([self.iN isKindOfClass:[IndefiniteLengthInputStream class]]) {
        [((IndefiniteLengthInputStream *)self.iN) setEofOn00:paramBoolean];
    }
}

@end
