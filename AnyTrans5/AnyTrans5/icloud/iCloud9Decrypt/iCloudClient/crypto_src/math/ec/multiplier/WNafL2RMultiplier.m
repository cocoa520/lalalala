//
//  WNafL2RMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "WNafL2RMultiplier.h"
#import "WNafUtilities.h"
#import "BigInteger.h"
#import "WNafPreCompInfo.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "LongArray.h"

@implementation WNafL2RMultiplier

/**
 * Multiplies <code>this</code> by an integer <code>k</code> using the
 * Window NAF method.
 * @param k The integer by which <code>this</code> is multiplied.
 * @return A new <code>ECPoint</code> which equals <code>this</code>
 * multiplied by <code>k</code>.
 */
- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        // Clamp the window width in the range [2, 16]
        int width = MAX(2, MIN(16, [self getWindowSize:[k bitLength]]));
        
        WNafPreCompInfo *wnafPreCompInfo = [WNafUtilities precompute:p withWidth:width withIncludeNegated:YES];
        // NSMutableArray == ECPoint[]
        NSMutableArray *preComp = [wnafPreCompInfo preComp];
        NSMutableArray *preCompNeg = [wnafPreCompInfo preCompNeg];
        
        // NSMutableArray == int[]
        NSMutableArray *wnaf = [WNafUtilities generateCompactWindowNaf:width withK:k];
        int i = (int)(wnaf.count);
        ECPoint *R = [[p curve] infinity];
        
        /*
         * NOTE: We try to optimize the first window using the precomputed points to substitute an
         * addition for 2 or more doublings.
         */
        if (i > 1) {
            int wi = [wnaf[--i] intValue];
            int digit = wi >> 16, zeroes = wi & 0xFFFF;
            
            int n = abs(digit);
            // NSMutableArray == ECPoint[]
            NSMutableArray *table = digit < 0 ? preCompNeg : preComp;
            
            // Optimization can only be used for values in the lower half of the table
            if ((n << 2) < (1 << width)) {
                int highest = ((Byte*)([LongArray BitLengths].bytes))[n];
                
                // TODO Get addition/doubling cost ratio from curve and compare to 'scale' to see if worth substituting?
                int scale = width - highest;
                int lowBits = n ^ (1 << (highest - 1));
                
                int i1 = ((1 << (width - 1)) - 1);
                int i2 = (lowBits << scale) + 1;
                R = [(ECPoint*)table[((uint)i1) >> 1] add:table[((uint)i2) >> 1]];
                zeroes -= scale;
            } else {
                R = table[n >> 1];
            }
            
            R = [R timesPow2:zeroes];
        }
        while (i > 0) {
            int wi = [wnaf[--i] intValue];
            int digit = wi >> 16, zeroes = wi & 0xFFFF;
            
            int n = abs(digit);
            // NSMutableArray == ECPoint[]
            NSMutableArray *table = digit < 0 ? preCompNeg : preComp;
            ECPoint *r = table[((uint)n) >> 1];
            
            R = [R twicePlus:r];
            R = [R timesPow2:zeroes];
        }
        retPoint = R;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

/**
 * Determine window width to use for a scalar multiplication of the given size.
 *
 * @param bits the bit-length of the scalar to multiply by
 * @return the window size to use
 */
- (int)getWindowSize:(int)bits {
    return [WNafUtilities getWindowSize:bits];
}

@end

