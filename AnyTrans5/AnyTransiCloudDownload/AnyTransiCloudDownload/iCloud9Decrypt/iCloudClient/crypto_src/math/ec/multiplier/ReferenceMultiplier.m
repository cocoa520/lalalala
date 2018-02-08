//
//  ReferenceMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "ReferenceMultiplier.h"
#import "ECAlgorithms.h"
#import "ECPoint.h"

@implementation ReferenceMultiplier

- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        retPoint = [ECAlgorithms referenceMultiply:p withK:k];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end
