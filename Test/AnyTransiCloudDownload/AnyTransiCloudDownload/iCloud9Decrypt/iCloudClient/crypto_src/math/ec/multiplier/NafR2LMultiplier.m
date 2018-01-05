//
//  NafR2LMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "NafR2LMultiplier.h"
#import "WNafUtilities.h"
#import "ECCurve.h"
#import "ECPoint.h"

@implementation NafR2LMultiplier

- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        // NSMutableArray == int[]
        NSMutableArray *naf = [WNafUtilities generateCompactNaf:k];
        
        ECPoint *R0 = [[p curve] infinity], *R1 = p;
        
        int zeroes = 0;
        for (int i = 0; i < naf.count; ++i) {
            int ni = [naf[i] intValue];
            int digit = ni >> 16;
            zeroes += ni & 0xFFFF;
            
            R1 = [R1 timesPow2:zeroes];
            R0 = [R0 add:(digit < 0 ? [R1 negate] : R1)];
            
            zeroes = 1;
        }
        retPoint = R0;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end
