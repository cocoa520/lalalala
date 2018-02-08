//
//  AbstractECMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "AbstractECMultiplier.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "BigInteger.h"
#import "ECAlgorithms.h"

@implementation AbstractECMultiplier

- (ECPoint*)multiply:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        int sign = [k signValue];
        if (sign == 0 || [p isInfinity]) {
            return [[p curve] infinity];
        }
        
        ECPoint *positive = [self multiplyPositive:p withK:[k abs]];
        ECPoint *result = sign > 0 ? positive : [positive negate];
        /*
         * Although the various multipliers ought not to produce invalid output under normal
         * circumstances, a final check here is advised to guard against fault attacks.
         */
        retPoint = [ECAlgorithms validatePoint:result];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    return nil;
}

@end
