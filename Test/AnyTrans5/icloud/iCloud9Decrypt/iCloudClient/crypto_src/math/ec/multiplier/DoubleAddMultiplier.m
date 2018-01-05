//
//  DoubleAddMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "DoubleAddMultiplier.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "BigInteger.h"

@implementation DoubleAddMultiplier

/**
 * Joye's double-add algorithm.
 */
- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        // R == ECPoint[]
        NSMutableArray *R = [[NSMutableArray alloc] initWithObjects:[[p curve] infinity], p, nil];
        
        int n = [k bitLength];
        for (int i = 0; i < n; ++i) {
            int b = [k testBitWithN:i] ? 1 : 0;
            int bp = 1 - b;
            R[bp] = [R[bp] twicePlus:R[b]];
        }
        retPoint = R[0];
        [retPoint retain];
#if !__has_feature(objc_arc)
        if (R) [R release]; R = nil;
#endif
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end
