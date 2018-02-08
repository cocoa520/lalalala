//
//  ANSSIObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ANSSIObjectIdentifiers.h"

@implementation ANSSIObjectIdentifiers

+ (ASN1ObjectIdentifier *)FRP256v1 {
    static ASN1ObjectIdentifier *_FRP256v1 = nil;
    @synchronized(self) {
        if (!_FRP256v1) {
            _FRP256v1 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.2.250.1.223.101.256.1"];
        }
    }
    return _FRP256v1;
}

@end
