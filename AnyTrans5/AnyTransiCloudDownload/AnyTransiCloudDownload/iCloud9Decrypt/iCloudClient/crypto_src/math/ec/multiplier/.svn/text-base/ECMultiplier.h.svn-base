//
//  ECMultiplier.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ECPoint;
@class BigInteger;

@interface ECMultiplier : NSObject

/**
 * Multiplies the <code>ECPoint p</code> by <code>k</code>, i.e.
 * <code>p</code> is added <code>k</code> times to itself.
 * @param p The <code>ECPoint</code> to be multiplied.
 * @param k The factor by which <code>p</code> is multiplied.
 * @return <code>p</code> multiplied by <code>k</code>.
 */
- (ECPoint*)multiply:(ECPoint*)p withK:(BigInteger*)k;

@end
