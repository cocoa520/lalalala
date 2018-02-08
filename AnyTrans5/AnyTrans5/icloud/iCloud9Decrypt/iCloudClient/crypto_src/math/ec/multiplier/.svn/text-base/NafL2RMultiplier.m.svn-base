//
//  NafL2RMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "NafL2RMultiplier.h"
#import "WNafUtilities.h"
#import "ECCurve.h"
#import "ECPoint.h"

@implementation NafL2RMultiplier

- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        // NSMutableArray == int[]
        NSMutableArray *naf = [WNafUtilities generateCompactNaf:k];
        
        ECPoint *addP = [p normalize], *subP = [addP negate];
        
        ECPoint *R = [[p curve] infinity];
        
        int i = (int)(naf.count);
        while (--i >= 0) {
            int ni = [naf[i] intValue];
            int digit = ni >> 16, zeroes = ni & 0xFFFF;
            
            R = [R twicePlus:(digit < 0 ? subP : addP)];
            R = [R timesPow2:zeroes];
        }
        retPoint = R;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end
