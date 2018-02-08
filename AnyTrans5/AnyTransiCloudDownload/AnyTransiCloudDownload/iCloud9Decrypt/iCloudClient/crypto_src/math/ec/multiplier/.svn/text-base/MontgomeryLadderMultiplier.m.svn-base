//
//  MontgomeryLadderMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "MontgomeryLadderMultiplier.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "BigInteger.h"

@implementation MontgomeryLadderMultiplier

/**
 * Montgomery ladder.
 */
- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        // NSMutableArray == ECPoint[]
        NSMutableArray *R = [[NSMutableArray alloc] initWithObjects:[[p curve] infinity], p, nil];
        
        int n = [k bitLength];
        int i = n;
        while (--i >= 0) {
            int b = [k testBitWithN:i] ? 1 : 0;
            int bp = 1 - b;
            R[bp] = [(ECPoint*)R[bp] add:R[b]];
            R[b] = [R[b] twice];
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
