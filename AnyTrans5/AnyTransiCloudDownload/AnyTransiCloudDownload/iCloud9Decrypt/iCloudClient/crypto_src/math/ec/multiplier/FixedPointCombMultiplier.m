//
//  FixedPointCombMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "FixedPointCombMultiplier.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "BigInteger.h"
#import "FixedPointUtilities.h"
#import "FixedPointPreCompInfo.h"

@implementation FixedPointCombMultiplier

- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECCurve *c = [p curve];
        int size = [FixedPointUtilities getCombSize:c];
        
        if ([k bitLength] > size) {
            /*
             * TODO The comb works best when the scalars are less than the (possibly unknown) order.
             * Still, if we want to handle larger scalars, we could allow customization of the comb
             * size, or alternatively we could deal with the 'extra' bits either by running the comb
             * multiple times as necessary, or by using an alternative multiplier as prelude.
             */
            @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"fixed-point comb doesn't support scalars larger than the curve order" userInfo:nil];
        }
        
        int minWidth = [self getWidthForCombSize:size];
        
        FixedPointPreCompInfo *info = [FixedPointUtilities precompute:p withMinWidth:minWidth];
        // lookupTable == ECPoint[]
        NSMutableArray *lookupTable = [info preComp];
        int width = [info width];
        
        int d = (size + width - 1) / width;
        ECPoint *R = [c infinity];
        int top = d * width - 1;
        for (int i = 0; i < d; ++i) {
            int index = 0;
            for (int j = top - i; j >= 0; j -= d) {
                index <<= 1;
                if ([k testBitWithN:j]) {
                    index |= 1;
                }
            }
            R = [R twicePlus:lookupTable[index]];
        }
        retPoint = R;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (int)getWidthForCombSize:(int)combSize {
    return combSize > 257 ? 6 : 5;
}

@end
