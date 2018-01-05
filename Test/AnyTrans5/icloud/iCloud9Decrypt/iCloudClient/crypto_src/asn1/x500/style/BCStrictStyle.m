//
//  BCStrictStyle.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BCStrictStyle.h"

@implementation BCStrictStyle

+ (X500NameStyle *)INSTANCE {
    static X500NameStyle *_INSTANCE = nil;
    @synchronized(self) {
        if (!_INSTANCE) {
            _INSTANCE = [[BCStrictStyle alloc] init];
        }
    }
    return _INSTANCE;
}

- (BOOL)areEqual:(X500Name *)paramX500Name1 paramX500Name2:(X500Name *)paramX500Name2 {
    NSMutableArray *arrayOfRDN1 = [paramX500Name1 getRDNS];
    NSMutableArray *arrayOfRDN2 = [paramX500Name2 getRDNS];
    if (arrayOfRDN1.count != arrayOfRDN2.count) {
        return NO;
    }
    for (int i = 0; i != arrayOfRDN1.count; i++) {
        if (![self rdnAreEqual:(RDN *)arrayOfRDN1[i] paramRDN2:(RDN *)arrayOfRDN2[i]]) {
            return NO;
        }
    }
    return YES;
}

@end
