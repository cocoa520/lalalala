//
//  NetscapeRevocationURL.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NetscapeRevocationURL.h"

@implementation NetscapeRevocationURL

- (instancetype)initParamDERIA5String:(DERIA5String *)paramDERIA5String
{
    self = [super initParamString:[paramDERIA5String getString]];
    if (self) {
        
    }
    return self;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"NetscapeRevocationURL: %@", [self getString]];
}

@end
