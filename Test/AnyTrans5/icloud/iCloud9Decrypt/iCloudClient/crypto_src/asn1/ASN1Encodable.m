//
//  ASN1Encodable.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Encodable.h"

@implementation ASN1Encodable

- (ASN1Primitive *)toASN1Primitive {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self retain];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self retain];
}

@end
