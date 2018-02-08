//
//  ECurves.m
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "ECurves.h"

@implementation ECurves

+ (NSString*)defaultCurve {
    return @"secp256r1";
}

+ (NSArray*)defaults {
    return [ECurves secpr1];
}

+ (NSArray*)secpr1 {
    return [[[NSMutableArray alloc] initWithArray:[ECurves SECPR1]] autorelease];
}

+ (NSArray*)SECPR1 {
    static NSArray *_secpr1 = nil;
    @synchronized(self) {
        if (_secpr1 == nil) {
            _secpr1 = [@[@"secp192r1", @"secp224r1", @"secp256r1", @"secp384r1", @"secp521r1"] retain];
        }
    }
    return _secpr1;
}

@end
