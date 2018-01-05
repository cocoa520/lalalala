//
//  ZSignedDigitR2LMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "ZSignedDigitR2LMultiplier.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "BigInteger.h"

@implementation ZSignedDigitR2LMultiplier

/**
 * 'Zeroless' Signed Digit Right-to-Left.
 */
- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECPoint *R0 = [[p curve] infinity], *R1 = p;
        
        int n = [k bitLength];
        int s = [k getLowestSetBit];
        
        R1 = [R1 timesPow2:s];
        
        int i = s;
        while (++i < n) {
            R0 = [R0 add:([k testBitWithN:i] ? R1 : [R1 negate])];
            R1 = [R1 twice];
        }
        
        R0 = [R0 add:R1];
        
        retPoint = R0;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end















