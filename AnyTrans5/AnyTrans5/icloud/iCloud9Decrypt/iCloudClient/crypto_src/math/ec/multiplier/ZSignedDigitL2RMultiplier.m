//
//  ZSignedDigitL2RMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "ZSignedDigitL2RMultiplier.h"
#import "ECPoint.h"
#import "BigInteger.h"

@implementation ZSignedDigitL2RMultiplier


/**
 * 'Zeroless' Signed Digit Left-to-Right.
 */
- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECPoint *addP = [p normalize], *subP = [addP negate];
        
        ECPoint *R0 = addP;
        
        int n = [k bitLength];
        int s = [k getLowestSetBit];
        
        int i = n;
        while (--i > s) {
            R0 = [R0 twicePlus:([k testBitWithN:i] ? addP : subP)];
        }
        
        R0 = [R0 timesPow2:s];
        
        retPoint = R0;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end
