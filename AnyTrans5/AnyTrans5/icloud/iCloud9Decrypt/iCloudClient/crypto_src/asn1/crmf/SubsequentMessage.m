//
//  SubsequentMessage.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SubsequentMessage.h"

@implementation SubsequentMessage

+ (SubsequentMessage *)encrCert {
    static SubsequentMessage *_encrCert = nil;
    @synchronized(self) {
        if (!_encrCert) {
            _encrCert = [[SubsequentMessage alloc] initParamInt:0];
        }
    }
    return _encrCert;
}

+ (SubsequentMessage *)challengeResp {
    static SubsequentMessage *_challengeResp = nil;
    @synchronized(self) {
        if (!_challengeResp) {
            _challengeResp = [[SubsequentMessage alloc] initParamInt:1];
        }
    }
    return _challengeResp;
}

- (instancetype)initParamInt:(int)paramInt
{
    self = [super initLong:paramInt];
    if (self) {
    }
    return self;
}

+ (SubsequentMessage *)valueOf:(int)paramInt {
    if (!paramInt) {
        return [SubsequentMessage encrCert];
    }
    if (paramInt == 1) {
        return [SubsequentMessage challengeResp];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown value: %d", paramInt] userInfo:nil];
}

@end
